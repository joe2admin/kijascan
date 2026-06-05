import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import 'package:kijascan/routes/app_routes.dart';
import '../models/scanned_employee.dart';

final ApiService _apiService = ApiService();
class CheckInController extends GetxController {
  final isLoadingEmployee = true.obs;
  final isSubmitting = false.obs;
  final employee = Rxn<ScannedEmployee>();
  final statusMessage = ''.obs;

  late final String _qrPayload;

  @override
  void onInit() {
    super.onInit();
    _qrPayload = Get.arguments as String? ?? '';
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
  isLoadingEmployee.value = true;
  try {
    // Call the API service instead of resolving mock data locally
    employee.value = await _apiService.fetchEmployee(_qrPayload);
  } catch (e) {
    statusMessage.value = e.toString();
  } finally {
    isLoadingEmployee.value = false;
  }
}

  String _formatToday() {
    final now = DateTime.now();
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
    return '${now.day} ${months[now.month - 1]} ${now.year}, ${weekdays[now.weekday - 1]}';
  }

  String _formatTimeNow() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  ScannedEmployee _resolveEmployee(String payload) {
    final key = payload.trim().toLowerCase();
    final today = _formatToday();

    const mockEmployees = <String, ScannedEmployee>{
      'user_uuid_987654321': ScannedEmployee(
        id: 'EMP-1042',
        fullName: 'Amina Okello',
        role: 'Field Officer',
        department: 'Operations',
        attendanceDate: '3 Jun 2026, Wednesday',
        checkedInTime: '8:12 AM',
        isCurrentlyCheckedIn: true,
      ),
      'emp-2048': ScannedEmployee(
        id: 'EMP-2048',
        fullName: 'James Mwangi',
        role: 'Supervisor',
        department: 'Logistics',
        attendanceDate: '2 Jun 2026, Tuesday',
        isCurrentlyCheckedIn: false,
      ),
    };

    if (mockEmployees.containsKey(key)) {
      final e = mockEmployees[key]!;
      return ScannedEmployee(
        id: e.id,
        fullName: e.fullName,
        role: e.role,
        department: e.department,
        attendanceDate: today,
        imageUrl: e.imageUrl,
        checkedInTime: e.checkedInTime,
        isCurrentlyCheckedIn: e.isCurrentlyCheckedIn,
      );
    }

    for (final entry in mockEmployees.entries) {
      if (key.contains(entry.key) ||
          key.contains(entry.value.id.toLowerCase())) {
        final e = entry.value;
        return ScannedEmployee(
          id: e.id,
          fullName: e.fullName,
          role: e.role,
          department: e.department,
          attendanceDate: today,
          imageUrl: e.imageUrl,
          checkedInTime: e.checkedInTime,
          isCurrentlyCheckedIn: e.isCurrentlyCheckedIn,
        );
      }
    }

    final displayId = payload.length > 12
        ? '${payload.substring(0, 8)}…'
        : (payload.isEmpty ? 'UNKNOWN' : payload);

    return ScannedEmployee(
      id: displayId.toUpperCase(),
      fullName: 'Scanned Employee',
      role: 'Staff',
      department: 'General',
      attendanceDate: today,
      isCurrentlyCheckedIn: false,
    );
  }

  Future<void> submitCheckIn() async {
    if (isSubmitting.value || employee.value == null) return;

    isSubmitting.value = true;
    statusMessage.value = 'Recording check-in…';

    await Future.delayed(const Duration(seconds: 1));

    final checkedInAt = _formatTimeNow();
    final name = employee.value!.fullName;

    isSubmitting.value = false;
    statusMessage.value = 'Clock-in recorded successfully.';

    Get.offNamedUntil(
      AppRoutes.checkInSuccess,
      (route) => route.settings.name == AppRoutes.main,
      arguments: {
        'message': statusMessage.value,
        'employeeName': name,
        'checkedInTime': checkedInAt,
        'date': employee.value!.attendanceDate,
      },
    );
  }

  void cancel() => Get.back();
}
