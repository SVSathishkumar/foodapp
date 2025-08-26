import 'package:get/get.dart';

class FavouritepageviewController extends GetxController {
 var favouriteItems = <Map<String, dynamic>>[].obs;

  bool isFavourite(Map<String, dynamic> product) {
    return favouriteItems.contains(product);
  }

  void toggleFavourite(Map<String, dynamic> product) {
    if (isFavourite(product)) {
      favouriteItems.remove(product);
    } else {
      favouriteItems.add(product);
    }
  }
}
