// lib/app/modules/loginpage/controllers/loginpage_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodapp/app/data/services/api_service.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';

class LoginpageController extends GetxController {
  var phoneNumber = ''.obs;
  var isValid = false.obs;
  var isPasswordVisible = false.obs;

  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  /// Auto-login if token exists
  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null && token.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => BottomnavigationbarView());
      });
    }
  }

  void validatePhone(String number) {
    isValid.value = number.length >= 10 && passwordController.text.isNotEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Login API call using ApiService
  Future<void> onLogin() async {
    String phone = phoneNumber.value.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showErrorSnackbar("Please enter phone and password");
      return;
    }

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
        barrierDismissible: false,
      );

      int phoneNumberInt = int.tryParse(phone) ?? 0;

      final response = await ApiService.postRequest("/access/login", {
        "phone_number": phoneNumberInt,
        "password": password,
      });

      Get.back();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          final userData = data["data"];
          final token = userData["token"];
          final phoneNumberStr = userData["phone_number"];

          if (token != null && token.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', token);
            await prefs.setString('userPhone', phoneNumberStr);
          }

          _showSuccessSnackbar(data["message"] ?? "Login Successful ✅");
          Get.offAll(() => BottomnavigationbarView());
        } else {
          _showErrorSnackbar(data["message"] ?? "Invalid credentials");
        }
      } else {
        _showErrorSnackbar("Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.back();
      _showErrorSnackbar("Network error: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
  }

  // === Snackbar Helpers ===
  void _showSuccessSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 183, 181, 181),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        messageText: Row(
          children: [
            Lottie.asset('assets/images/Success.json', width: 40, height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          "Error",
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 200, 199, 199),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        messageText: Row(
          children: [
            Lottie.asset('assets/images/Failed.json', width: 50, height: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
