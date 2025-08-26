import 'package:get/get.dart';

import '../controllers/pizzascreenpage_controller.dart';

class PizzascreenpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PizzascreenpageController>(
      () => PizzascreenpageController(),
    );
  }
}
