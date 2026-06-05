import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import '../models/history_record.dart';

enum HistoryFilter { all, today, week }

class HistoryController extends GetxController {
  final isLoading = true.obs;
  final selectedFilter = HistoryFilter.all.obs;
  final groups = <HistoryDayGroup>[].obs;
  final todayCount = 0.obs;
  final weekCount = 0.obs;
  final totalCount = 0.obs;
  final errorMessage = ''.obs;

  final ApiService _apiService = ApiService();
  List<HistoryRecord> _records = [];

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      _records = await _apiService.fetchHistory();
      _refreshView();
    } catch (e) {
      errorMessage.value = 'Failed to load history.';
      _records = [];
      groups.clear();
      todayCount.value = 0;
      weekCount.value = 0;
      totalCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(HistoryFilter filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void addRecord(HistoryRecord record) {
    final existingIndex = _records.indexWhere((r) => r.id == record.id);
    if (existingIndex >= 0) {
      _records[existingIndex] = record;
    } else {
      _records.insert(0, record);
    }
    _refreshView();
  }

  void _refreshView() {
    _updateStats();
    _applyFilter();
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    final filtered = _records.where((record) {
      final day = DateTime(
        record.checkedOutAt.year,
        record.checkedOutAt.month,
        record.checkedOutAt.day,
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

    groups.assignAll(_groupRecords(filtered));
  }

  void _updateStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    var todayTotal = 0;
    var weekTotal = 0;

    for (final record in _records) {
      final day = DateTime(
        record.checkedOutAt.year,
        record.checkedOutAt.month,
        record.checkedOutAt.day,
      );
      if (day == today) todayTotal++;
      if (!day.isBefore(weekStart)) weekTotal++;
    }

    todayCount.value = todayTotal;
    weekCount.value = weekTotal;
    totalCount.value = _records.length;
  }

  List<HistoryDayGroup> _groupRecords(List<HistoryRecord> records) {
    final sorted = [...records]
      ..sort((a, b) => b.checkedOutAt.compareTo(a.checkedOutAt));

    final byDay = <DateTime, List<HistoryRecord>>{};
    for (final record in sorted) {
      final day = DateTime(
        record.checkedOutAt.year,
        record.checkedOutAt.month,
        record.checkedOutAt.day,
      );
      byDay.putIfAbsent(day, () => []).add(record);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return byDay.entries.map((entry) {
      final day = entry.key;
      return HistoryDayGroup(
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
