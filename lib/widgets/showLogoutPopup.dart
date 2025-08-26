import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/phonescreenpage/views/phonescreenpage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';

/// 🔹 Reusable Logout Popup
void showLogoutPopup({required bool isDark}) {
  final context = Get.context!;
  final size = MediaQuery.of(context).size;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ?  Color.fromARGB(255, 236, 202, 100)
              : Colors.pink, // 👉 card side border color
          width: 1.5,
        ),
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 👉 Lottie animation
            Lottie.asset('assets/images/give order.json', height: size.width * 0.5),
             SizedBox(height: 16),

            Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color.fromARGB(255, 245, 203, 78)
                        : Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.offAll(() => PhonescreenpageView());
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isDark ? Colors.black : Colors.amber,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // close dialog only
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// 🔹 Drawer Tile Builder
Widget buildDrawerTile(
  IconData icon,
  String title,
  VoidCallback onTap,
  double textScale,
  bool isDark,
) {
  return ListTile(
    leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
    title: Text(
      title,
      textScaleFactor: textScale,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: () {
      if (title == "Logout") {
        showLogoutPopup(isDark: isDark);
      } else {
        onTap();
      }
    },
  );
}
