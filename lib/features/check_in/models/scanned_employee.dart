class ScannedEmployee {
  final String id;
  final String fullName;
  final String role;
  final String department;
  final String attendanceDate;
  final String? imageUrl;
  final String? checkedInTime;
  final bool isCurrentlyCheckedIn;

  const ScannedEmployee({
    required this.id,
    required this.fullName,
    required this.role,
    required this.department,
    required this.attendanceDate,
    this.imageUrl,
    this.checkedInTime,
    this.isCurrentlyCheckedIn = false,
  });

  factory ScannedEmployee.fromJson(Map<String, dynamic> json) {
    return ScannedEmployee(
      // The ?.toString() safely converts numbers like 1 to "1"
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      role: json['position']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      attendanceDate: json['attendance_date']?.toString() ?? '',
      imageUrl: json['profile_picture']?.toString(),
      checkedInTime: json['clock_in']?.toString(),

      // For boolean, if Laravel returns 0 or 1, we can handle it like this:
      isCurrentlyCheckedIn:
          json['is_currently_checked_in'] == true ||
          json['is_currently_checked_in'] == 1,
    );
  }

  String get checkedInTimeDisplay =>
      checkedInTime?.isNotEmpty == true ? checkedInTime! : '—';
}
