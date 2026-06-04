import 'package:get/get.dart';
import '../controllers/bulk_clock_out_controller.dart';

class BulkClockOutBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BulkClockOutController());
  }
}
