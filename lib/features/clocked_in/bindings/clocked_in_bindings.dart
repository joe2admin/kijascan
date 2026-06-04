import 'package:get/get.dart';
import '../controllers/clocked_in_controller.dart';

class ClockedInBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClockedInController>(() => ClockedInController(), fenix: true);
  }
}
