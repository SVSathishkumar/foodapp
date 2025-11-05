import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/myorderpage_controller.dart';

class MyorderpageView extends GetView<MyorderpageController> {
  const MyorderpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.03;
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 249, 209, 88)
            : Colors.pink,
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => BottomnavigationbarView());
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Obx(() {
            if (controller.orders.isEmpty) {
              return Center(
                child: Text(
                  "No orders yet!",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding / 2,
                ),
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 900),
                    child: SlideAnimation(
                      horizontalOffset: 50,
                      child: FadeInAnimation(
                        child: Dismissible(
                          key: Key(order["id"]!),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color.fromARGB(255, 243, 205, 90)
                                  : Colors.pink,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            controller.orders.removeAt(index);

                            // 🔥 Animated Snackbar from Top
                            Flushbar(
                              margin: const EdgeInsets.all(12),
                              borderRadius: BorderRadius.circular(12),
                              backgroundColor: isDark
                                  ? Colors.pink
                                  : const Color.fromARGB(255, 245, 203, 79),
                              duration: const Duration(seconds: 2),
                              flushbarPosition: FlushbarPosition.TOP,
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                                size: 28,
                              ),
                              messageText: Text(
                                "${order["item"]} removed from orders",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              titleText: Text(
                                "Order Deleted",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              animationDuration: const Duration(
                                milliseconds: 500,
                              ), // Smooth
                              forwardAnimationCurve: Curves.easeOutBack,
                            ).show(context);
                          },
                          child: _buildOrderTile(order, size, padding, isDark),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrderTile(
    Map<String, String> order,
    Size size,
    double padding,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: padding / 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color.fromARGB(255, 21, 21, 21)!,
                  const Color.fromARGB(255, 24, 24, 24)!,
                ]
              : [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding / 2,
        ),
        leading: CircleAvatar(
          radius: size.width * 0.05,
          backgroundColor: isDark
              ? const Color.fromARGB(255, 242, 202, 83)
              : Colors.pink,
          child: Icon(
            Icons.shopping_bag,
            color: Colors.white,
            size: size.width * 0.05,
          ),
        ),
        title: Text(
          order["item"] ?? "",
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              order["shop"] ?? "",
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.032,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(order["status"] ?? "").withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order["status"] ?? "",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.027,
                  color: isDark
                      ? _getStatusColor(order["status"] ?? "")
                      : _getStatusColor(order["status"] ?? ""),
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          "${order["price"] ?? "0"}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.04,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Out for delivery":
        return Colors.blue;
      case "Cooking":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
