import 'package:get/get.dart';
import 'package:kijascan/features/clocked_in/controllers/clocked_in_controller.dart';
import 'package:kijascan/features/history/controllers/history_controller.dart';
import 'package:kijascan/features/main_shell/controllers/main_shell_controller.dart';
import 'package:kijascan/features/qr_scanner/controllers/qr_scanner_controller.dart';

class MainShellBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<QrScannerController>(() => QrScannerController(), fenix: true);
    Get.lazyPut<ClockedInController>(() => ClockedInController(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}
