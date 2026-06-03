class ScannedEmployee {
  final String id;
  final String fullName;
  final String role;
  final String department;
  final String? lastCheckInAt;
  final bool isCurrentlyCheckedIn;

  const ScannedEmployee({
    required this.id,
    required this.fullName,
    required this.role,
    required this.department,
    this.lastCheckInAt,
    this.isCurrentlyCheckedIn = false,
  });
}
