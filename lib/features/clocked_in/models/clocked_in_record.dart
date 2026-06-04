class ClockedInRecord {
  final String id;
  final String employeeName;
  final String employeeId;
  final String role;
  final String? department;
  final DateTime checkedInAt;

  const ClockedInRecord({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.role,
    this.department,
    required this.checkedInAt,
  });

  String get departmentLabel {
    final value = department?.trim();
    if (value == null || value.isEmpty) return '-';
    return value;
  }

  String get timeLabel {
    final hour = checkedInAt.hour > 12
        ? checkedInAt.hour - 12
        : (checkedInAt.hour == 0 ? 12 : checkedInAt.hour);
    final minute = checkedInAt.minute.toString().padLeft(2, '0');
    final period = checkedInAt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

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
}

class ClockedInDayGroup {
  final String title;
  final String subtitle;
  final List<ClockedInRecord> records;

  const ClockedInDayGroup({
    required this.title,
    required this.subtitle,
    required this.records,
  });
}
