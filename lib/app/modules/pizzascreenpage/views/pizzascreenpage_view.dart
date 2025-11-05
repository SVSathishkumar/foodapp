import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodapp/app/modules/addcartpageviews/views/addcartpageviews_view.dart';
import 'package:foodapp/app/modules/favouritepageview/controllers/favouritepageview_controller.dart';
import 'package:foodapp/app/modules/favouritepageview/views/favouritepageview_view.dart';
import 'package:foodapp/app/modules/notificationspage/views/notificationspage_view.dart';
import 'package:foodapp/app/modules/productdetailspage/views/productdetailspage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PizzascreenpageView extends StatelessWidget {
  PizzascreenpageView({super.key});

  final FavouritepageviewController controller = Get.find();

  final List<Map<String, dynamic>> products = [
    {"title": "Tomato", "price": "₹40/kg", "image": "assets/images/Tomato.png"},
    {"title": "Potato", "price": "₹30/kg", "image": "assets/images/Potato.png"},
    {"title": "Onion", "price": "₹35/kg", "image": "assets/images/Onion.png"},
    {
      "title": "Brinjal (Eggplant)",
      "price": "₹50/kg",
      "image": "assets/images/Brinjal.png",
    },
    {"title": "Carrot", "price": "₹60/kg", "image": "assets/images/Carrot.png"},
    {
      "title": "Beetroot",
      "price": "₹45/kg",
      "image": "assets/images/Beetroot.png",
    },
    {
      "title": "Cabbage",
      "price": "₹40/kg",
      "image": "assets/images/Cabbage.png",
    },
    {
      "title": "Cauliflower",
      "price": "₹55/kg",
      "image": "assets/images/Cauliflower.png",
    },
    {
      "title": "Greenbeans",
      "price": "₹70/kg",
      "image": "assets/images/Greenbeans.png",
    },
    {
      "title": "Bottlegourd (Lauki/Sorakkai)",
      "price": "₹35/kg",
      "image": "assets/images/Bottlegourd.png",
    },
    {
      "title": "Ridgegourd (Turai/Peerkangai)",
      "price": "₹50/kg",
      "image": "assets/images/Ridgegourd.png",
    },
    {
      "title": "Bittergourd (Karela/Pavakkai)",
      "price": "₹60/kg",
      "image": "assets/images/Bittergourd.png",
    },
    {
      "title": "Snakegourd (Pudalangai)",
      "price": "₹40/kg",
      "image": "assets/images/Snakegourd.png",
    },
    {
      "title": "Drumstick (Moringa)",
      "price": "₹80/kg",
      "image": "assets/images/Drumstick.png",
    },
    {
      "title": "Lady’sfinger (Okra/Bhindi/Vendakkai)",
      "price": "₹60/kg",
      "image": "assets/images/Lady’sfinger.png",
    },
    {
      "title": "Greenpeas",
      "price": "₹90/kg",
      "image": "assets/images/Greenpeas.png",
    },
    {
      "title": "Capsicum (Bell pepper)",
      "price": "₹80/kg",
      "image": "assets/images/Capsicum.png",
    },
    {
      "title": "Spinach (Palak)",
      "price": "₹25/bunch",
      "image": "assets/images/Spinach.png",
    },
    {
      "title": "Corianderleaves",
      "price": "₹15/bunch",
      "image": "assets/images/Corianderleaves.png",
    },
    {
      "title": "Mintleaves",
      "price": "₹20/bunch",
      "image": "assets/images/Mintleaves.png",
    },
    {
      "title": "Springonion",
      "price": "₹30/bunch",
      "image": "assets/images/Springonion.png",
    },
    {"title": "Turnip", "price": "₹50/kg", "image": "assets/images/Turnip.png"},
    {
      "title": "Knolkhol (Kohlrabi/Navalkol)",
      "price": "₹40/kg",
      "image": "assets/images/Knolkhol.png",
    },
    {
      "title": "Ashgourd (White pumpkin/Poosanikai)",
      "price": "₹35/kg",
      "image": "assets/images/Ashgourd.png",
    },
    {
      "title": "Pumpkin (Yellow pumpkin/Mathan)",
      "price": "₹30/kg",
      "image": "assets/images/Pumpkin.png",
    },
    {
      "title": "Raw banana (Vazhakkai)",
      "price": "₹45/kg",
      "image": "assets/images/Rawbanana.png",
    },
    {
      "title": "Raw mango",
      "price": "₹70/kg",
      "image": "assets/images/Rawmango.png",
    },
    {
      "title": "Taro root (Arbi/Cheppankizhangu)",
      "price": "₹80/kg",
      "image": "assets/images/Taroroot.png",
    },
    {
      "title": "Yam (Suran/Karunai kizhangu)",
      "price": "₹60/kg",
      "image": "assets/images/Yam.png",
    },
    {
      "title": "Cluster beans (Gawar/Kothavarangai)",
      "price": "₹55/kg",
      "image": "assets/images/Cluster beans.png",
    },
    {
      "title": "Broad beans (Avarakkai)",
      "price": "₹50/kg",
      "image": "assets/images/Broad beans.png",
    },
    {
      "title": "Colocasia leaves (Taro leaves)",
      "price": "₹30/bunch",
      "image": "assets/images/Colocasia leaves.png",
    },
    {
      "title": "Mustard greens (Sarson ka saag)",
      "price": "₹25/bunch",
      "image": "assets/images/Mustard greens.png",
    },
    {
      "title": "Fenugreek leaves (Methi)",
      "price": "₹20/bunch",
      "image": "assets/images/Fenugreek leaves.png",
    },
    {
      "title": "Dill leaves (Soya)",
      "price": "₹20/bunch",
      "image": "assets/images/Dill leaves.png",
    },
    {
      "title": "Raw jackfruit",
      "price": "₹60/kg",
      "image": "assets/images/Raw jackfruit.png",
    },
    {
      "title": "Sweet corn",
      "price": "₹50/kg",
      "image": "assets/images/Sweet corn.png",
    },
    {
      "title": "Cucumber",
      "price": "₹40/kg",
      "image": "assets/images/Cucumber.png",
    },
    {
      "title": "Radish (Mooli/Mullangi)",
      "price": "₹30/kg",
      "image": "assets/images/Radish.png",
    },
    {"title": "Lemon", "price": "₹80/kg", "image": "assets/images/Lemon.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    // ---------- Responsive Sizes ----------
    final padding = screenWidth * 0.04;
    final imageSize = screenWidth * 0.35;
    final titleFontSize = screenWidth < 600 ? 12 : 16;
    final priceFontSize = screenWidth * 0.035;

    // Responsive grid count (mobile / tablet / web)
    final crossAxisCount = screenWidth >= 600
        ? 5
        : screenWidth >= 900
        ? 4
        : screenWidth >= 600
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Veg Menu",
          style: GoogleFonts.poppins(
            fontSize: titleFontSize + 2,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: textColor),
                onPressed: () {
                  Get.to(() => AddcartpageviewsView());
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: screenWidth * 0.02,
                  backgroundColor: Colors.red,
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: screenWidth * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: textColor),
            onPressed: () {
              Get.to(NotificationspageView());
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: textColor),
            onPressed: () {
              Get.to(FavouritepageviewView());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
          child: AnimationLimiter(
            child: GridView.builder(
              padding:  EdgeInsets.only(bottom: 20),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: crossAxisCount,
                  duration:Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ProductDetailsViewpageView(),
                            arguments: {
                              'images': [product['image']],
                              'title': product['title'],
                              'price': product['price'],
                              'oldPrice': '₹450',
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: imageSize,
                                  height: imageSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? const Color.fromARGB(255, 40, 39, 39)
                                        : const Color.fromARGB(
                                            255,
                                            239,
                                            238,
                                            238,
                                          ),
                                    boxShadow: [
                                      if (!isDark)
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                        ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(product["image"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Obx(() {
                                    final isFav = controller.isFavourite(
                                      product,
                                    );
                                    return GestureDetector(
                                      onTap: () {
                                        controller.toggleFavourite(product);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          screenWidth * 0.015,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            if (!isDark)
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                              ),
                                          ],
                                        ),
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFav
                                              ? Colors.amber
                                              : Colors.grey,
                                          size: screenWidth * 0.045,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product["title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize.toDouble(),
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              product["price"],
                              style: GoogleFonts.poppins(
                                fontSize: priceFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
