class HistoryRecord {
  final String id;
  final String employeeName;
  final String employeeId;
  final String role;
  final String? department;
  final DateTime checkedInAt;
  final DateTime checkedOutAt;

  const HistoryRecord({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.role,
    this.department,
    required this.checkedInAt,
    required this.checkedOutAt,
  });

  String get departmentLabel {
    final value = department?.trim();
    if (value == null || value.isEmpty) return '-';
    return value;
  }

  String get checkedInTimeLabel => _formatTime(checkedInAt);

  String get checkedOutTimeLabel => _formatTime(checkedOutAt);

  String get dateLabel {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
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
    return '${checkedInAt.day} ${months[checkedInAt.month - 1]} ${checkedInAt.year}, ${weekdays[checkedInAt.weekday - 1]}';
  }

  String get durationLabel {
    final duration = checkedOutAt.difference(checkedInAt);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours <= 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  static String _formatTime(DateTime value) {
    final hour = value.hour > 12
        ? value.hour - 12
        : (value.hour == 0 ? 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class HistoryDayGroup {
  final String title;
  final String subtitle;
  final List<HistoryRecord> records;

  const HistoryDayGroup({
    required this.title,
    required this.subtitle,
    required this.records,
  });
}
