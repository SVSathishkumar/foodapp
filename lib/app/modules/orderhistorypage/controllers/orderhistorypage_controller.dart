import 'package:get/get.dart';

class OrderhistorypageController extends GetxController {
/// Cart items (reordered items will be added here)
  var cartItems = <Map<String, dynamic>>[].obs;

  /// All previous orders
  var orders = <Map<String, dynamic>>[].obs;

  /// Clear complete history
  void clearHistory() {
    orders.clear();
  }
  
}
