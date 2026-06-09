import 'package:get/get.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShellController extends GetxController {
  final currentIndex = 1.obs;
  static const String _tabKey = 'last_selected_tab_index';

  @override
  void onInit() {
    super.onInit();
    _loadPersistedTab();
  }

  Future<void> _loadPersistedTab() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_tabKey);
      if (savedIndex != null && savedIndex >= 0 && savedIndex <= 2) {
        setTab(savedIndex);
      }
    } catch (e) {
      // Ignore errors when loading
    }
  }

  void setTab(int index) async {
    if (index < 0 || index > 2) return;
    if (index == currentIndex.value) return;

    final leavingScan = currentIndex.value == 1;
    currentIndex.value = index;

    // Persist the newly selected tab
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_tabKey, index);
    } catch (e) {
      // Ignore errors when saving
    }

    if (!Get.isRegistered<QrScannerController>()) return;

    final scanner = Get.find<QrScannerController>();
    if (leavingScan && index != 1) {
      scanner.pauseCamera();
    } else if (index == 1) {
      scanner.resumeCamera();
    }
  }

  void goToScanTab() => setTab(1);
}
