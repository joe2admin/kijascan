import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:kijascan/core/services/audio_service.dart';
import '../models/scanned_employee.dart';

class CheckInController extends GetxController {
  final isLoadingEmployee = true.obs;
  final isSubmitting = false.obs;
  final employee = Rxn<ScannedEmployee>();
  final statusMessage = ''.obs;

  final ApiService _apiService = ApiService();

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
      employee.value = await _apiService.fetchEmployee(_qrPayload);
    } catch (e) {
      statusMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoadingEmployee.value = false;
    }
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

  Future<void> submitCheckIn() async {
    if (isSubmitting.value || employee.value == null) return;

    isSubmitting.value = true;
    statusMessage.value = 'Recording check-in…';

    final success = await _apiService.submitClockIn(employee.value!.id);

    isSubmitting.value = false;
    if (success) {
      AudioService.playCheckInSound();
      statusMessage.value = 'Clock-in recorded successfully.';
      final checkedInAt = _formatTimeNow();
      final name = employee.value!.fullName;
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
    } else {
      statusMessage.value = 'Failed to record clock-in. Please try again.';
      Get.snackbar(
        'Error',
        statusMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void cancel() => Get.back();
}
