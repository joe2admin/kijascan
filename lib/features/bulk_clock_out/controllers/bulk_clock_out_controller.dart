import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/core/services/audio_service.dart';

class BulkClockOutController extends GetxController {
  final isLoading = true.obs;
  final isProcessing = false.obs;
  final employees = <ClockedInRecord>[].obs;
  final selectedIds = <String>{}.obs;
  final selectAll = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List?;
    if (args != null && args.isNotEmpty) {
      final allGroups = List<ClockedInDayGroup>.from(args);
      _loadFromGroups(allGroups);
    } else {
      _loadFromApi();
    }
  }

  void _loadFromGroups(List<ClockedInDayGroup> allGroups) {
    isLoading.value = true;
    final allEmployees = <ClockedInRecord>[];
    for (final group in allGroups) {
      allEmployees.addAll(group.records);
    }
    employees.value = allEmployees;
    isLoading.value = false;
  }

  Future<void> _loadFromApi() async {
    isLoading.value = true;
    try {
      employees.value = await _apiService.fetchActiveClockedIn();
    } catch (e) {
      employees.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    _updateSelectAllState();
    selectedIds.refresh();
  }

  void toggleSelectAll(bool value) {
    selectAll.value = value;
    selectedIds.clear();
    if (value) {
      selectedIds.addAll(employees.map((e) => e.id));
    }
    selectedIds.refresh();
  }

  void _updateSelectAllState() {
    selectAll.value =
        selectedIds.length == employees.length && employees.isNotEmpty;
  }

  bool isSelected(String id) => selectedIds.contains(id);

  int get selectedCount => selectedIds.length;

  bool get hasSelection => selectedIds.isNotEmpty;

  Future<void> submitBulkClockOut() async {
    if (isProcessing.value || !hasSelection) return;

    isProcessing.value = true;

    final success =
        await _apiService.submitBulkClockOut(selectedIds.toList());

    isProcessing.value = false;

    if (success) {
      AudioService.playCheckOutSound();
      // Refresh the clocked-in list
      if (Get.isRegistered<ClockedInController>()) {
        Get.find<ClockedInController>().loadClockedIn();
      }

      Get.back();
      Get.snackbar(
        'Bulk Clock Out Complete',
        '${selectedIds.length} employee(s) have been checked out.',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to clock out employees. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void cancel() {
    Get.back();
  }
}
