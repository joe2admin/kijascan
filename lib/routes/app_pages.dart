import 'package:get/get.dart';
import 'app_routes.dart';

import '../features/check_in/bindings/check_in_bindings.dart';
import '../features/check_in/presentation/screens/check_in_screen.dart';
import '../features/check_in/presentation/screens/check_in_success_screen.dart';
import '../features/main_shell/bindings/main_shell_bindings.dart';
import '../features/main_shell/presentation/screens/main_shell_screen.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.main;

  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainShellScreen(),
      binding: MainShellBindings(),
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
