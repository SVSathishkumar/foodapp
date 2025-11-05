import 'package:foodapp/app/data/services/api_home.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var allItems = <Map<String, String>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await ApiHome.fetchItems();
      allItems.value = data.map<Map<String, String>>((item) {
        return {
          'title': item['name']?.toString() ?? '',
          'price': '₹${item['price']?.toString() ?? '0'}',
          'oldPrice': '₹${((item['price'] ?? 0) + 20).toString()}',
          'image': item['image_url']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  List<Map<String, String>> get filteredItems {
    if (searchQuery.value.isEmpty) return allItems;
    return allItems
        .where(
          (item) => item['title']!.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
