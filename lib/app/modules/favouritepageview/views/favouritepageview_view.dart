import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/productdetailspage/views/productdetailspage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/favouritepageview_controller.dart';

class FavouritepageviewView extends GetView<FavouritepageviewController> {
  FavouritepageviewView({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,

        body: Obx(() {
          if (controller.favouriteItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      "assets/images/favtouriteesese.png",
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'No favorites yet!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Looks like you haven’t added any favorites yet.\nStart exploring and save what you love!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favouriteItems.length,
            itemBuilder: (context, index) {
              final item = controller.favouriteItems[index];

              return TweenAnimationBuilder<Offset>(
                duration: const Duration(milliseconds: 800),
                tween: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ),
                curve: Curves.easeOut,
                builder: (context, offset, child) =>
                    Transform.translate(offset: offset * 50, child: child),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.red.shade700 : Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onDismissed: (_) {
                    controller.toggleFavourite(item);
                    Get.snackbar(
                      "Product Removed",
                      "",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: isDark
                          ? const Color.fromARGB(160, 255, 82, 82)
                          : const Color.fromARGB(158, 243, 114, 105),
                      borderRadius: 12,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(8),
                      duration: const Duration(seconds: 3),
                      titleText: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const Text(
                            "Removed",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      messageText: Text(
                        "${item['title']} has been removed\nfrom your favourites successfully.\nYou can add it back anytime.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    shadowColor: isDark ? Colors.black26 : Colors.grey.shade200,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? Colors.grey.shade700 : Colors.black,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item['image'] ?? '',
                                  width: 110,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.029,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RatingBarIndicator(
                                      rating:
                                          double.tryParse(
                                            item['rating'].toString(),
                                          ) ??
                                          4.0,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 18.0,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['price'].toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 2,
                          child: Container(
                            height: 36,
                            width: 40,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.yellow[600] // dark mode
                                  : Colors.pink, // light mode

                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black45
                                      : Colors.grey.shade300,
                                  offset: const Offset(0, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ProductDetailsViewpageView(),
                                  arguments: {
                                    'images': [item['image'] ?? ''],
                                    'title': item['title'] ?? '',
                                    'price': item['price'].toString(),
                                    'oldPrice': item['oldPrice'].toString(),
                                  },
                                );
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
