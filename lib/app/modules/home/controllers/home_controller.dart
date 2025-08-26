import 'package:get/get.dart';

class HomeController extends GetxController {
  var searchQuery = ''.obs;

  final List<Map<String, String>> allItems = [
    {
      'image': 'assets/images/Fresh Organic Carrot.png',
      'title': 'Fresh Organic Carrot',
      'price': '₹34',
      'oldPrice': '₹49.95',
    },
    {
      'image': 'assets/images/Green Capsicum.png',
      'title': 'Green Capsicum',
      'price': '₹44',
      'oldPrice': '₹59.95',
    },
    {
      'image': 'assets/images/Tomato (500g).png',
      'title': 'Tomato (500g)',
      'price': '₹24',
      'oldPrice': '₹34.95',
    },
    {
      'image': 'assets/images/Potato (1kg).png',
      'title': 'Potato (1kg)',
      'price': '₹39',
      'oldPrice': '₹54.95',
    },
  ];

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
