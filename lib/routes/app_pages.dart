import 'package:get/get.dart';
import 'app_routes.dart';

import '../features/check_in/bindings/check_in_bindings.dart';
import '../features/check_in/presentation/screens/check_in_screen.dart';
import '../features/check_in/presentation/screens/check_in_success_screen.dart';
import '../features/history/bindings/history_bindings.dart';
import '../features/history/presentation/screens/history_screen.dart';
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
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryScreen(),
      binding: HistoryBindings(),
    ),
  ];
}
