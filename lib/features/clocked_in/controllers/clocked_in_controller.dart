import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import 'package:kijascan/core/services/audio_service.dart';
import '../models/clocked_in_record.dart';

enum ClockedInFilter { all, today }

class ClockedInController extends GetxController {
  final isLoading = true.obs;
  final selectedFilter = ClockedInFilter.today.obs;
  final groups = <ClockedInDayGroup>[].obs;
  final todayCount = 0.obs;
  final weekCount = 0.obs;
  final totalCount = 0.obs;
  final isCheckingOut = false.obs;
  final errorMessage = ''.obs;

  final ApiService _apiService = ApiService();
  List<ClockedInRecord> _allRecords = [];

  @override
  void onInit() {
    super.onInit();
    loadClockedIn();
  }

  Future<void> loadClockedIn() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('ClockedInController - Starting to load clocked-in data...');
      _allRecords = await _apiService.fetchActiveClockedIn();
      print('ClockedInController - Loaded ${_allRecords.length} records');
      _updateStats();
      _applyFilter();
      print('ClockedInController - Groups after filter: ${groups.length}');
      if (groups.isNotEmpty) {
        print(
          'ClockedInController - First group has ${groups[0].records.length} records',
        );
      }
    } catch (e) {
      print('ClockedInController - Error loading: $e');
      errorMessage.value = 'Failed to load clocked-in data.';
      _allRecords = [];
      groups.clear();
      todayCount.value = 0;
      weekCount.value = 0;
      totalCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(ClockedInFilter filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  Future<void> submitCheckOut(ClockedInRecord record) async {
    if (isCheckingOut.value) return;

    isCheckingOut.value = true;

    final success = await _apiService.submitClockOut(record.id);

    if (success) {
      AudioService.playCheckOutSound();
      // Remove from local list and refresh
      _allRecords = _allRecords.where((r) => r.id != record.id).toList();
      _updateStats();
      _applyFilter();

      Get.back();

      Get.snackbar(
        'Checked out',
        '${record.employeeName} has been checked out.',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to clock out ${record.employeeName}. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }

    isCheckingOut.value = false;
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    print(
      '_applyFilter - Filter: ${selectedFilter.value}, Total records: ${_allRecords.length}',
    );
    print('_applyFilter - Today: $today');

    final filtered = _allRecords.where((record) {
      final day = DateTime(
        record.checkedInAt.year,
        record.checkedInAt.month,
        record.checkedInAt.day,
      );
      print(
        '_applyFilter - Record day: $day, checkedInAt: ${record.checkedInAt}',
      );
      switch (selectedFilter.value) {
        case ClockedInFilter.today:
          final match = day == today;
          print('_applyFilter - Today filter, day == today: $match');
          return match;
        case ClockedInFilter.all:
          return true;
      }
    }).toList();

    print('_applyFilter - Filtered records: ${filtered.length}');
    groups.value = _groupRecords(filtered);
  }

  List<ClockedInDayGroup> _groupRecords(List<ClockedInRecord> records) {
    final sorted = [...records]
      ..sort((a, b) => b.checkedInAt.compareTo(a.checkedInAt));

    final byDay = <DateTime, List<ClockedInRecord>>{};
    for (final record in sorted) {
      final day = DateTime(
        record.checkedInAt.year,
        record.checkedInAt.month,
        record.checkedInAt.day,
      );
      byDay.putIfAbsent(day, () => []).add(record);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return byDay.entries.map((entry) {
      final day = entry.key;
      return ClockedInDayGroup(
        title: _dayTitle(day, today, yesterday),
        subtitle: _formatDate(day),
        records: entry.value,
      );
    }).toList();
  }

  String _dayTitle(DateTime day, DateTime today, DateTime yesterday) {
    if (day == today) return 'Today';
    if (day == yesterday) return 'Yesterday';
    return 'Earlier';
  }

  void _updateStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    var todayTotal = 0;
    var weekTotal = 0;

    for (final record in _allRecords) {
      final day = DateTime(
        record.checkedInAt.year,
        record.checkedInAt.month,
        record.checkedInAt.day,
      );
      if (day == today) todayTotal++;
      if (!day.isBefore(weekStart)) weekTotal++;
    }

    todayCount.value = todayTotal;
    weekCount.value = weekTotal;
    totalCount.value = _allRecords.length;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
