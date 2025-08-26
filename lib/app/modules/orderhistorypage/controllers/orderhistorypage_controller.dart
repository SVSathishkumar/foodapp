import 'package:get/get.dart';

class OrderhistorypageController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
 var orders = <Map<String, dynamic>>[].obs;

  void clearHistory() {
    orders.clear();
  }
}
