import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}
