import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'pusher_service.dart';
import 'dart:developer';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';

class RealtimeEventsController extends GetxController {
  final PusherService _pusherService = PusherService();

  @override
  void onInit() {
    super.onInit();
    _initPusher();
  }

  Future<void> _initPusher() async {
    // 1. Initialize pusher service
    await _pusherService.init();

    // 2. Set up the global event listener
    _pusherService.onEventReceived = _handleEvent;

    // Subscribe to workforce and attendance channels
    await _pusherService.subscribe('attendance');
    await _pusherService.subscribe('workforce');
    await _pusherService.subscribe('products');
  }

  void _handleEvent(PusherEvent event) {
    try {
      log("Realtime Controller received: ${event.eventName}");
      
      // Parse data if available
      Map<String, dynamic>? data;
      if (event.data is String) {
        data = jsonDecode(event.data);
      }

      // Handle specific events here
      switch (event.eventName) {
        case 'attendance.updated':
        case '.attendance.updated':
          log("Attendance Updated Event Received: $data");
          Get.snackbar(
            "Attendance Update",
            data?['action'] ?? "An employee's attendance was updated.",
            snackPosition: SnackPosition.TOP,
          );
          
          // Real-time UI refresh
          if (Get.isRegistered<ClockedInController>()) {
            Get.find<ClockedInController>().loadClockedIn();
          }
          if (Get.isRegistered<HistoryController>()) {
            Get.find<HistoryController>().loadHistory();
          }
          break;
        case 'workforce.updated':
        case '.workforce.updated':
          log("Workforce Updated Event Received: $data");
          break;
        case 'App\\Events\\ProductCreated':
          log("Product Created: $data");
          // Update state or show snackbar
          break;
        case 'App\\Events\\ProductUpdated':
          log("Product Updated: $data");
          break;
        case 'App\\Events\\ProductDeleted':
          log("Product Deleted: $data");
          break;
        default:
          log("Unhandled event: ${event.eventName}");
      }
    } catch (e) {
      log("Error parsing pusher event data: $e");
    }
  }

  @override
  void onClose() {
    // Unsubscribe from channels if needed when controller closes
    _pusherService.unsubscribe('products');
    _pusherService.unsubscribe('test-channel');
    super.onClose();
  }
}
