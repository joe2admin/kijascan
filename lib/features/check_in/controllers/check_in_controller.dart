import 'package:get/get.dart';
import 'package:kijascan/routes/app_routes.dart';
import '../models/scanned_employee.dart';

enum CheckInAction { checkIn, checkOut }

class CheckInController extends GetxController {
  final isLoadingEmployee = true.obs;
  final isSubmitting = false.obs;
  final employee = Rxn<ScannedEmployee>();
  final statusMessage = ''.obs;
  final lastAction = Rxn<CheckInAction>();

  late final String _qrPayload;

  @override
  void onInit() {
    super.onInit();
    _qrPayload = Get.arguments as String? ?? '';
    _loadEmployee();
  }

  Future<void> _loadEmployee() async {
    isLoadingEmployee.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    employee.value = _resolveEmployee(_qrPayload);
    isLoadingEmployee.value = false;
  }

  ScannedEmployee _resolveEmployee(String payload) {
    final key = payload.trim().toLowerCase();
    const mockEmployees = <String, ScannedEmployee>{
      'user_uuid_987654321': ScannedEmployee(
        id: 'EMP-1042',
        fullName: 'Amina Okello',
        role: 'Field Officer',
        department: 'Operations',
        lastCheckInAt: 'Today, 08:12 AM',
        isCurrentlyCheckedIn: true,
      ),
      'emp-2048': ScannedEmployee(
        id: 'EMP-2048',
        fullName: 'James Mwangi',
        role: 'Supervisor',
        department: 'Logistics',
        lastCheckInAt: 'Yesterday, 5:45 PM',
        isCurrentlyCheckedIn: false,
      ),
    };

    if (mockEmployees.containsKey(key)) {
      return mockEmployees[key]!;
    }

    for (final entry in mockEmployees.entries) {
      if (key.contains(entry.key) || key.contains(entry.value.id.toLowerCase())) {
        return entry.value;
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
      isCurrentlyCheckedIn: false,
    );
  }

  Future<void> submitCheckIn(CheckInAction action) async {
    if (isSubmitting.value || employee.value == null) return;

    isSubmitting.value = true;
    lastAction.value = action;
    statusMessage.value = action == CheckInAction.checkIn
        ? 'Recording check-in…'
        : 'Recording check-out…';

    await Future.delayed(const Duration(seconds: 1));

    isSubmitting.value = false;
    statusMessage.value = action == CheckInAction.checkIn
        ? 'Check-in recorded successfully.'
        : 'Check-out recorded successfully.';

    Get.offNamedUntil(
      AppRoutes.checkInSuccess,
      (route) => route.settings.name == AppRoutes.qrScanner,
      arguments: {
        'message': statusMessage.value,
        'employeeName': employee.value!.fullName,
        'action': action.name,
      },
    );
  }

  void cancel() => Get.back();
}
