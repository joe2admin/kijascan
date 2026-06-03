import 'package:get/get.dart';
import '../controllers/qr_scanner_controller.dart';

class QrScannerBindings extends Bindings {
  @override
  void dependencies(){
    // lazyPut ensures the controller is initialized only when needed
    Get.lazyPut<QrScannerController>(
      () => QrScannerController(),
      fenix: true,
    );
  }
}