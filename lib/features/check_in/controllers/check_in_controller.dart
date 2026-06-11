import 'package:get/get.dart';
import 'package:kijascan/core/services/api_services.dart';
import 'package:kijascan/routes/app_routes.dart';
import 'package:kijascan/core/services/audio_service.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/utils/popups/custom_snackbar.dart';
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
    final isClockOut = employee.value!.isCurrentlyCheckedIn;

    statusMessage.value = isClockOut ? 'Recording clock-out…' : 'Recording clock-in…';

    final success = isClockOut
        ? await _apiService.submitClockOut(employee.value!.id)
        : await _apiService.submitClockIn(employee.value!.id);

    isSubmitting.value = false;
    if (success) {
      AudioService.playCheckInSound();
      statusMessage.value = isClockOut ? 'Clock-out recorded successfully.' : 'Clock-in recorded successfully.';

      if (Get.isRegistered<ClockedInController>()) {
        Get.find<ClockedInController>().loadClockedIn();
      }
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().loadHistory();
      }

      final timeNow = _formatTimeNow();
      final name = employee.value!.fullName;
      Get.offNamedUntil(
        AppRoutes.checkInSuccess,
        (route) => route.settings.name == AppRoutes.main,
        arguments: {
          'message': statusMessage.value,
          'employeeName': name,
          'checkedInTime': timeNow,
          'date': employee.value!.attendanceDate,
          'isClockOut': isClockOut,
        },
      );
    } else {
      statusMessage.value = isClockOut ? 'Failed to record clock-out. Please try again.' : 'Failed to record clock-in. Please try again.';
      CustomSnackbar.showError(
        title: 'Error',
        message: statusMessage.value,
      );
    }
  }

  void cancel() => Get.back();
}
