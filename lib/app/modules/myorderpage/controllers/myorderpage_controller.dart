import 'package:get/get.dart';

class MyorderpageController extends GetxController {
  
 var orders = <Map<String, String>>[
  {
    "id": "ORD201",
    "item": "Tomato (1kg)",
    "shop": "Fresh Mart",
    "price": "₹40",
    "status": "Delivered"
  },
  {
    "id": "ORD202",
    "item": "Onion (2kg)",
    "shop": "Farm Fresh",
    "price": "₹70",
    "status": "Out for delivery"
  },
  {
    "id": "ORD203",
    "item": "Potato (5kg)",
    "shop": "Veggie World",
    "price": "₹150",
    "status": "Cooking"
  },
  {
    "id": "ORD204",
    "item": "Carrot (1kg)",
    "shop": "Fresh Mart",
    "price": "₹60",
    "status": "Delivered"
  },
  {
    "id": "ORD205",
    "item": "Capsicum (500g)",
    "shop": "Veggie World",
    "price": "₹45",
    "status": "Out for delivery"
  },
  {
    "id": "ORD206",
    "item": "Cucumber (1kg)",
    "shop": "Farm Fresh",
    "price": "₹50",
    "status": "Cooking"
  },
  {
    "id": "ORD207",
    "item": "Tomato (2kg)",
    "shop": "Fresh Mart",
    "price": "₹80",
    "status": "Delivered"
  },
  {
    "id": "ORD208",
    "item": "Onion (1kg)",
    "shop": "Veggie World",
    "price": "₹35",
    "status": "Out for delivery"
  },
  {
    "id": "ORD209",
    "item": "Potato (2kg)",
    "shop": "Farm Fresh",
    "price": "₹60",
    "status": "Cooking"
  },
  {
    "id": "ORD210",
    "item": "Spinach (1 bunch)",
    "shop": "Fresh Mart",
    "price": "₹30",
    "status": "Delivered"
  },
].obs;

}
