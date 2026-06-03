import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kijascan/features/bottom_nav_bar.dart/presentation/screens/bottom_nav_bar_screen.dart';
import 'package:kijascan/features/history/presentation/screens/history_screen.dart';
import 'package:kijascan/features/main_shell/controllers/main_shell_controller.dart';
import 'package:kijascan/features/qr_scanner/presentation/screens/qr_scanner_screen.dart';

class MainShellScreen extends GetView<MainShellController> {
  const MainShellScreen({super.key});

  static const double _navBarBottomPadding = 12;
  static const double _navBarHorizontalPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.currentIndex.value;
      final isScanTab = index == 1;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: isScanTab ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: isScanTab ? Colors.black : HistoryScreen.backgroundColor,
          body: IndexedStack(
            index: index,
            children: const [
              HistoryScreen(),
              QrScannerScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: _navBarBottomPadding),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _navBarHorizontalPadding,
              ),
              child: ScannerBottomNavBar(
                selectedIndex: index,
                onTabChanged: controller.setTab,
              ),
            ),
          ),
        ),
      );
    });
  }
}
