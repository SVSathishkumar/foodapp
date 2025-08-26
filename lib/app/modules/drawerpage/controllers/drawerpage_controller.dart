import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DrawerpageController extends GetxController {
   final Rx<File?> profileImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }
}
