import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/widgets/showaddtocartpopup.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:action_slider/action_slider.dart';
import 'package:foodapp/app/modules/addcartpageviews/controllers/addcartpageviews_controller.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';

class ProductDetailsViewpageView extends StatefulWidget {
  const ProductDetailsViewpageView({super.key});

  @override
  State<ProductDetailsViewpageView> createState() => _FoodDetailsViewState();
}

class _FoodDetailsViewState extends State<ProductDetailsViewpageView> {
  final AddcartpageviewsController cartController =
      Get.find<AddcartpageviewsController>();

  final storage = GetStorage(); // ✅ Persistent storage

  int currentPage = 0;
  int quantity = 1;

  late List<String> images;
  late String title;
  late String price;
  late String oldPrice;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    images = List<String>.from(args['images'] ?? [args['image']] ?? []);
    title = args['title'] ?? 'Food Item';
    price = args['price'] ?? '₹0';
    oldPrice = args['oldPrice'] ?? '₹0';
  }

  int parsePrice(String priceStr) {
    return int.tryParse(priceStr.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  Future<void> _shareProduct() async {
    try {
      final imagePath = images[currentPage];
      final byteData = await rootBundle.load(imagePath);
      final Uint8List bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_food.jpg').create();
      await file.writeAsBytes(bytes);

      final shareText =
          '''
🍽️ Dish: $title
💸 Price: $price
❌ Old Price: $oldPrice
🛒 Order now on FoodApp!
''';

      await Share.shareXFiles([XFile(file.path)], text: shareText);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to share food item",
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  final Set<String> _popupShownProducts = {};

  bool get isDark => Get.isDarkMode;

  void onAddToCartPopup() {
    if (!_popupShownProducts.contains(title)) {
      _popupShownProducts.add(title);

      showAddToCartPopup(
        title: title,
        image: images[currentPage],
        quantity: quantity,
        totalPrice: "₹${parsePrice(price) * quantity}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    int unitPrice = parsePrice(price);
    int totalPrice = unitPrice * quantity;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white, size: width * 0.06),
            onPressed: _shareProduct,
          ),
          SizedBox(width: width * 0.02),
        ],
      ),
      body: Stack(
        children: [
          if (images.isNotEmpty)
            Positioned.fill(
              child: Image.asset(images[currentPage], fit: BoxFit.cover),
            ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + height * 0.05,
              bottom: height * 0.03,
            ),
            child: Container(
              margin: EdgeInsets.only(top: height * 0.3),
              padding: EdgeInsets.all(width * 0.05),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.97),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(width * 0.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: width * 0.05,
                    offset: Offset(0, -height * 0.01),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.04),
                        child: Image.asset(images[index], fit: BoxFit.cover),
                      );
                    },
                    options: CarouselOptions(
                      height: height * 0.25,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, _) {
                        setState(() => currentPage = index);
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.034 * textScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  Row(
                    children: [
                      Text(
                        "₹$totalPrice",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.045 * textScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        oldPrice,
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.04 * textScale,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.025),

                  Text(
                    "Select Quantity",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04 * textScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: width * 0.07,
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.045 * textScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: width * 0.07,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.025),

                  Text(
                    "Ingredients",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.035 * textScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    "Fresh veggies, spices, organic base, and chef's secret sauce. Prepared with love and hygiene guaranteed.",
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.030 * textScale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: height * 0.04),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: ActionSlider.standard(
                      backgroundColor: isDark
                          ? Colors.orange.shade300
                          : Colors.pinkAccent,
                      toggleColor: Colors.white,
                      icon: Icon(
                        Icons.shopping_bag,
                        size:
                            MediaQuery.of(context).size.width *
                            0.06, // responsive icon
                        color: isDark
                            ? Colors.orange.shade300
                            : Colors.pinkAccent,
                      ),
                      successIcon: CircleAvatar(
                        radius:
                            MediaQuery.of(context).size.width *
                            0.045, // responsive radius
                        backgroundColor: isDark ? Colors.white : Colors.black,
                        child: Icon(
                          Icons.check,
                          color: isDark ? Colors.black : Colors.white,
                          size:
                              MediaQuery.of(context).size.width *
                              0.045, // responsive icon
                        ),
                      ),
                      child: Text(
                        'Add To Cart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor *
                              MediaQuery.of(context).size.width *
                              0.04, // responsive font
                        ),
                      ),
                      height:
                          MediaQuery.of(context).size.height *
                          0.065, // responsive height
                      sliderBehavior: SliderBehavior.stretch,
                      action: (controller) async {
                        controller.loading();
                        await Future.delayed(
                          const Duration(milliseconds: 1000),
                        );

                        cartController.addItem({
                          'image': images[currentPage],
                          'title': title,
                          'unitPrice': price,
                          'quantity': quantity.toString(),
                          'totalPrice': "₹$totalPrice",
                        });

                        controller.success();

                        onAddToCartPopup(); // ✅ One-time popup

                        await Future.delayed(const Duration(milliseconds: 800));

                        controller.reset();
                        Get.to(() => BottomnavigationbarView());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
