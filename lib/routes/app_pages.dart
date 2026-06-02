import 'package:get/get.dart';
import 'app_routes.dart';

import '../features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import '../features/qr_scanner/bindings/qr_scanner_bindings.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.qrScanner;

  static final routes = [
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => const QrScannerScreen(),
      binding: QrScannerBindings(),
    ),
  ];
}
