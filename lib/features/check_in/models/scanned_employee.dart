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

  String get checkedInTimeDisplay =>
      checkedInTime?.isNotEmpty == true ? checkedInTime! : '—';
}
