import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/clocked_in_record.dart';

enum ClockedInFilter { all, today, week }

class ClockedInController extends GetxController {
  final isLoading = true.obs;
  final selectedFilter = ClockedInFilter.today.obs;
  final groups = <ClockedInDayGroup>[].obs;
  final todayCount = 0.obs;
  final weekCount = 0.obs;
  final isCheckingOut = false.obs;

  List<ClockedInDayGroup> _allGroups = [];

  @override
  void onInit() {
    super.onInit();
    loadClockedIn();
  }

  Future<void> loadClockedIn() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    _allGroups = _mockClockedIn();
    _updateStats();
    _applyFilter();
    isLoading.value = false;
  }

  void setFilter(ClockedInFilter filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  Future<void> submitCheckOut(ClockedInRecord record) async {
    if (isCheckingOut.value) return;

    isCheckingOut.value = true;
    await Future.delayed(const Duration(seconds: 1));
    _removeRecord(record);
    isCheckingOut.value = false;

    Get.back();

    Get.snackbar(
      'Checked out',
      '${record.employeeName} has been checked out.',
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _removeRecord(ClockedInRecord record) {
    _allGroups = _allGroups
        .map(
          (group) => ClockedInDayGroup(
            title: group.title,
            subtitle: group.subtitle,
            records: group.records.where((r) => r.id != record.id).toList(),
          ),
        )
        .where((group) => group.records.isNotEmpty)
        .toList();
    _updateStats();
    _applyFilter();
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
              case ClockedInFilter.today:
                return day == today;
              case ClockedInFilter.week:
                return !day.isBefore(weekStart);
              case ClockedInFilter.all:
                return true;
            }
          }).toList();
          return ClockedInDayGroup(
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

  List<ClockedInDayGroup> _mockClockedIn() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      ClockedInDayGroup(
        title: 'Today',
        subtitle: _formatDate(today),
        records: [
          ClockedInRecord(
            id: '1',
            employeeName: 'Amina Okello',
            employeeId: 'EMP-1042',
            role: 'Field Officer',
            department: 'Operations',
            checkedInAt: today.add(const Duration(hours: 8, minutes: 12)),
          ),
          ClockedInRecord(
            id: '2',
            employeeName: 'James Mwangi',
            employeeId: 'EMP-2048',
            role: 'Supervisor',
            department: 'Logistics',
            checkedInAt: today.add(const Duration(hours: 9, minutes: 5)),
          ),
          ClockedInRecord(
            id: '3',
            employeeName: 'Sarah Njoroge',
            employeeId: 'EMP-3011',
            role: 'Analyst',
            department: 'Finance',
            checkedInAt: today.add(const Duration(hours: 10, minutes: 42)),
          ),
        ],
      ),
      ClockedInDayGroup(
        title: 'Yesterday',
        subtitle: _formatDate(yesterday),
        records: [
          ClockedInRecord(
            id: '4',
            employeeName: 'David Kimani',
            employeeId: 'EMP-1180',
            role: 'Technician',
            department: 'Maintenance',
            checkedInAt: yesterday.add(const Duration(hours: 7, minutes: 55)),
          ),
          ClockedInRecord(
            id: '5',
            employeeName: 'Grace Wanjiku',
            employeeId: 'EMP-2205',
            role: 'Coordinator',
            department: 'HR',
            checkedInAt: yesterday.add(const Duration(hours: 14, minutes: 20)),
          ),
        ],
      ),
      ClockedInDayGroup(
        title: 'Earlier',
        subtitle: _formatDate(today.subtract(const Duration(days: 3))),
        records: [
          ClockedInRecord(
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
