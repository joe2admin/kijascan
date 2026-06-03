import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/attendance_record.dart';

enum HistoryFilter { all, today, week }

class HistoryController extends GetxController {
  final isLoading = true.obs;
  final selectedFilter = HistoryFilter.today.obs;
  final groups = <HistoryDayGroup>[].obs;
  final todayCount = 0.obs;
  final weekCount = 0.obs;
  final isCheckingOut = false.obs;

  List<HistoryDayGroup> _allGroups = [];

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    _allGroups = _mockHistory();
    _updateStats();
    _applyFilter();
    isLoading.value = false;
  }

  void setFilter(HistoryFilter filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  Future<void> submitCheckOut(AttendanceRecord record) async {
    if (isCheckingOut.value) return;

    isCheckingOut.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isCheckingOut.value = false;

    Get.back();

    Get.snackbar(
      'Checked out',
      '${record.employeeName} has been checked out.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    groups.value = _allGroups
        .map((group) {
          final filtered = group.records.where((record) {
            final day = DateTime(
              record.checkedInAt.year,
              record.checkedInAt.month,
              record.checkedInAt.day,
            );
            switch (selectedFilter.value) {
              case HistoryFilter.today:
                return day == today;
              case HistoryFilter.week:
                return !day.isBefore(weekStart);
              case HistoryFilter.all:
                return true;
            }
          }).toList();
          return HistoryDayGroup(
            title: group.title,
            subtitle: group.subtitle,
            records: filtered,
          );
        })
        .where((g) => g.records.isNotEmpty)
        .toList();
  }

  void _updateStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    var todayTotal = 0;
    var weekTotal = 0;

    for (final group in _allGroups) {
      for (final record in group.records) {
        final day = DateTime(
          record.checkedInAt.year,
          record.checkedInAt.month,
          record.checkedInAt.day,
        );
        if (day == today) todayTotal++;
        if (!day.isBefore(weekStart)) weekTotal++;
      }
    }

    todayCount.value = todayTotal;
    weekCount.value = weekTotal;
  }

  List<HistoryDayGroup> _mockHistory() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      HistoryDayGroup(
        title: 'Today',
        subtitle: _formatDate(today),
        records: [
          AttendanceRecord(
            id: '1',
            employeeName: 'Amina Okello',
            employeeId: 'EMP-1042',
            role: 'Field Officer',
            department: 'Operations',
            checkedInAt: today.add(const Duration(hours: 8, minutes: 12)),
          ),
          AttendanceRecord(
            id: '2',
            employeeName: 'James Mwangi',
            employeeId: 'EMP-2048',
            role: 'Supervisor',
            department: 'Logistics',
            checkedInAt: today.add(const Duration(hours: 9, minutes: 5)),
          ),
          AttendanceRecord(
            id: '3',
            employeeName: 'Sarah Njoroge',
            employeeId: 'EMP-3011',
            role: 'Analyst',
            department: 'Finance',
            checkedInAt: today.add(const Duration(hours: 10, minutes: 42)),
          ),
        ],
      ),
      HistoryDayGroup(
        title: 'Yesterday',
        subtitle: _formatDate(yesterday),
        records: [
          AttendanceRecord(
            id: '4',
            employeeName: 'David Kimani',
            employeeId: 'EMP-1180',
            role: 'Technician',
            department: 'Maintenance',
            checkedInAt: yesterday.add(const Duration(hours: 7, minutes: 55)),
          ),
          AttendanceRecord(
            id: '5',
            employeeName: 'Grace Wanjiku',
            employeeId: 'EMP-2205',
            role: 'Coordinator',
            department: 'HR',
            checkedInAt: yesterday.add(const Duration(hours: 14, minutes: 20)),
          ),
        ],
      ),
      HistoryDayGroup(
        title: 'Earlier',
        subtitle: _formatDate(today.subtract(const Duration(days: 3))),
        records: [
          AttendanceRecord(
            id: '6',
            employeeName: 'Peter Ochieng',
            employeeId: 'EMP-1099',
            role: 'Driver',
            department: 'Transport',
            checkedInAt: today.subtract(const Duration(days: 3, hours: -8)),
          ),
        ],
      ),
    ];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
