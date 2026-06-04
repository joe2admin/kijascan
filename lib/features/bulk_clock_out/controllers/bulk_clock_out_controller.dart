import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/clocked_in/models/clocked_in_record.dart';
import 'package:kijascan/routes/app_routes.dart';

class BulkClockOutController extends GetxController {
  final isLoading = true.obs;
  final isProcessing = false.obs;
  final employees = <dynamic>[].obs;
  final selectedIds = <String>{}.obs;
  final selectAll = false.obs;

  List<ClockedInDayGroup> _allGroups = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List?;
    if (args != null && args.isNotEmpty) {
      _allGroups = List<ClockedInDayGroup>.from(args);
    }
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    // Flatten all records from all day groups
    final allEmployees = <dynamic>[];
    for (final group in _allGroups) {
      allEmployees.addAll(group.records);
    }

    employees.value = allEmployees;
    isLoading.value = false;
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    _updateSelectAllState();
  }

  void toggleSelectAll(bool value) {
    selectAll.value = value;
    if (value) {
      selectedIds.value = employees.map((e) => _getId(e)).toSet();
    } else {
      selectedIds.clear();
    }
  }

  void _updateSelectAllState() {
    selectAll.value =
        selectedIds.length == employees.length && employees.isNotEmpty;
  }

  String _getId(dynamic employee) {
    if (employee is ClockedInRecord) {
      return employee.id;
    }
    return employee.id as String;
  }

  bool isSelected(String id) => selectedIds.contains(id);

  int get selectedCount => selectedIds.length;

  bool get hasSelection => selectedIds.isNotEmpty;

  Future<void> submitBulkClockOut() async {
    if (isProcessing.value || !hasSelection) return;

    isProcessing.value = true;
    await Future.delayed(const Duration(seconds: 1));

    final selectedEmployees = employees
        .where((e) => selectedIds.contains(_getId(e)))
        .toList();

    isProcessing.value = false;

    Get.back();
    Get.snackbar(
      'Bulk Clock Out Complete',
      '${selectedEmployees.length} employee(s) have been checked out.',
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void cancel() {
    Get.back();
  }
}
