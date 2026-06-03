import 'package:get/get.dart';
import 'app_routes.dart';

import '../features/check_in/bindings/check_in_bindings.dart';
import '../features/check_in/presentation/screens/check_in_screen.dart';
import '../features/check_in/presentation/screens/check_in_success_screen.dart';
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
    GetPage(
      name: AppRoutes.checkIn,
      page: () => const CheckInScreen(),
      binding: CheckInBindings(),
    ),
    GetPage(
      name: AppRoutes.checkInSuccess,
      page: () => const CheckInSuccessScreen(),
    ),
  ];
}
