import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilescreenpageController extends GetxController {
  // Holds path to profile image, default asset path initially
  var profileImage = 'assets/images/user_avatar.png'.obs;
  var selectedLanguage = 'English'.obs; // Default language
  var userName = 'John Doe'.obs;
  var email = 'john.doe@example.com'.obs;
  var favoriteCuisine = 'Italian'.obs;
  var phone = '123-456-7890'.obs;
  final List<dynamic> _items = [];

  List<dynamic> get cartItems => _items;

  final ImagePicker _picker = ImagePicker();

  get phoneNumber => null;

  // Pick image from camera

  // Pick image from gallery (optional)
  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = picked.path;
    }
  }

  void logout() {
    Get.offAllNamed('/login');
  }

  void addItem(dynamic item) {
    _items.add(item);
    update(); // If using GetX for UI updates
  }
}
