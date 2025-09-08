import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/barsstickspage/views/barsstickspage_view.dart';
import 'package:foodapp/app/modules/bisleriwaterpage/views/bisleriwaterpage_view.dart';
import 'package:foodapp/app/modules/burgerscreenpage/views/burgerscreenpage_view.dart';
import 'package:foodapp/app/modules/conespagescreen/views/conespagescreen_view.dart';
import 'package:foodapp/app/modules/familypackspage/views/familypackspage_view.dart';
import 'package:foodapp/app/modules/noodelsscreenpage/views/noodelsscreenpage_view.dart';
import 'package:foodapp/app/modules/pizzascreenpage/views/pizzascreenpage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';

import '../controllers/categorypage_controller.dart';

class CategorypageView extends GetView<CategorypageController> {
  const CategorypageView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Vegetables", "items": "25 items", "image": "assets/images/cartegories.png"},
      {"name": "Fruits", "items": "30 items", "image": "assets/images/cartegories1.png"},
      {"name": "Ice Cream", "items": "30 items", "image": "assets/images/cartegories2.png"},
      {"name": "Cones", "items": "44 items", "image": "assets/images/cartegories3.png"},
      {"name": "Bars & Sticks", "items": "30 items", "image": "assets/images/cartegories4.png"},
      {"name": "Family Packs", "items": "18 items", "image": "assets/images/cartegories6.png"},
      {"name": "Bisleri Water", "items": "10 items", "image": "assets/images/cartegories5.png"},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double cardRadius = screenWidth * 0.08;
    double avatarRadius = screenWidth * 0.1;
    double titleSize = screenWidth * 0.036;
    double subtitleSize = screenWidth * 0.029;
    double spacing = screenHeight * 0.008;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: isDark ? const Color.fromARGB(255, 250, 210, 89) : Colors.pink,
        elevation: 0,
        title: Text(
          "Categories",
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.scaffoldBackgroundColor : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cardRadius),
            topRight: Radius.circular(cardRadius),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(screenWidth * 0.04),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            // Target screen based on category
            Widget getTargetScreen() {
              switch (category["name"]) {
                case 'Vegetables':
                  return PizzascreenpageView();
                case 'Fruits':
                  return BurgerscreenpageView();
                case 'Ice Cream':
                  return NoodelsscreenpageView();
                case 'Cones':
                  return ConespagescreenView();
                case 'Bars & Sticks':
                  return BarsstickspageView();
                case 'Family Packs':
                  return FamilypackspageView();
                case 'Bisleri Water':
                  return bisleriWaterPageView();
                default:
                  return Scaffold(
                    appBar: AppBar(title:  Text("Coming Soon")),
                    body: const Center(child: Text("This category is not ready yet")),
                  );
              }
            }

            // 🎬 Animation: slide from top with delay
            return TweenAnimationBuilder(
              tween: Tween<Offset>(
                begin: const Offset(0, -0.5), // start slightly above
                end: Offset.zero,
              ),
              duration: Duration(milliseconds: 2100 + (index * 100)), // stagger
              curve: Curves.easeOutBack,
              builder: (context, Offset offset, child) {
                return Transform.translate(
                  offset: offset * 120, // pixel shift
                  child: Opacity(
                    opacity: 1 - offset.dy.abs()*0.8,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedElevation: 5,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadius),
                  ),
                  closedBuilder: (context, action) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.025,
                            horizontal: screenWidth * 0.05,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? theme.cardColor : Colors.white,
                            borderRadius: BorderRadius.circular(cardRadius),
                            boxShadow: isDark
                                ? []
                                : [
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                            border: Border.all(
                              color: isDark
                                  ? const Color.fromARGB(255, 245, 140, 175)
                                  : const Color.fromARGB(255, 249, 213, 107),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: avatarRadius * 2.2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category["name"]!,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: titleSize,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: spacing),
                                    Text(
                                      category["items"]!,
                                      style: GoogleFonts.poppins(
                                        fontSize: subtitleSize,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFFF9D25D) : Colors.pink,
                                  shape: BoxShape.circle,
                                  boxShadow: isDark
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: screenWidth * 0.025,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: screenWidth * 0.045,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left:-2,
                          top: -2,
                          child: CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color.fromARGB(255, 255, 255, 255),
                            child: Image.asset(
                              category["image"]!,
                              fit: BoxFit.cover,
                              width: avatarRadius * 2.15,
                              height: avatarRadius * 1.9,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  openBuilder: (context, action) => getTargetScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
