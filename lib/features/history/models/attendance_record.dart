class AttendanceRecord {
  final String id;
  final String employeeName;
  final String employeeId;
  final String role;
  final DateTime checkedInAt;

  const AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.role,
    required this.checkedInAt,
  });

  String get timeLabel {
    final hour = checkedInAt.hour > 12
        ? checkedInAt.hour - 12
        : (checkedInAt.hour == 0 ? 12 : checkedInAt.hour);
    final minute = checkedInAt.minute.toString().padLeft(2, '0');
    final period = checkedInAt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class HistoryDayGroup {
  final String title;
  final String subtitle;
  final List<AttendanceRecord> records;

  const HistoryDayGroup({
    required this.title,
    required this.subtitle,
    required this.records,
  });
}
