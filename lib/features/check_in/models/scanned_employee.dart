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
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['position'] ?? '',
      department: json['department'] ?? '',
      attendanceDate: json['attendance_date'] ?? '',
      imageUrl: json['profile_picture'],
      checkedInTime: json['clock_in'],
      isCurrentlyCheckedIn: json['is_currently_checked_in'] ?? false,
    );
  }

  String get checkedInTimeDisplay =>
      checkedInTime?.isNotEmpty == true ? checkedInTime! : '—';
}
