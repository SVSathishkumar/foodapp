import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddcartpageviewsController extends GetxController {
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  RxDouble subTotal = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble totalWithDiscount = 0.0.obs;

  TextEditingController discountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    calculateSubTotal();

    // Listen to discount input changes
    discountController.addListener(applyDiscount);
  }

  void addItem(Map<String, dynamic> item) {
    cartItems.add(item);
    calculateSubTotal();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    calculateSubTotal();
  }

  void clearCart() {
    cartItems.clear();
    discountController.clear();
    discount.value = 0.0;
    calculateSubTotal();
  }

  void increaseQuantity(int index) {
    int quantity = int.tryParse(cartItems[index]['quantity'].toString()) ?? 1;
    quantity++;
    cartItems[index]['quantity'] = quantity.toString();
    cartItems.refresh();
    calculateSubTotal();
  }

  void decreaseQuantity(int index) {
    int quantity = int.tryParse(cartItems[index]['quantity'].toString()) ?? 1;
    if (quantity > 1) {
      quantity--;
      cartItems[index]['quantity'] = quantity.toString();
      cartItems.refresh();
      calculateSubTotal();
    }
  }

  void calculateSubTotal() {
    double total = 0;
    for (var item in cartItems) {
      int price = int.tryParse(item['unitPrice'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      int quantity = int.tryParse(item['quantity'].toString()) ?? 1;
      total += price * quantity;
    }
    subTotal.value = total;
    applyDiscount();
  }

  void applyDiscount() {
    final input = double.tryParse(discountController.text) ?? 0.0;
    discount.value = input.clamp(0, subTotal.value);
    totalWithDiscount.value = subTotal.value - discount.value;
  }

  int getTotal() => totalWithDiscount.value.toInt();
}
