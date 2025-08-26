import 'package:get/get.dart';

import '../controllers/categorypageview_controller.dart';

class CategorypageviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategorypageviewController>(
      () => CategorypageviewController(),
    );
  }
}
