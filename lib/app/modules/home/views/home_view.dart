import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/addcartpageviews/views/addcartpageviews_view.dart';
import 'package:foodapp/app/modules/barsstickspage/views/barsstickspage_view.dart';
import 'package:foodapp/app/modules/burgerscreenpage/views/burgerscreenpage_view.dart';
import 'package:foodapp/app/modules/conespagescreen/views/conespagescreen_view.dart';
import 'package:foodapp/app/modules/drawerpage/views/drawerpage_view.dart';
import 'package:foodapp/app/modules/familypackspage/views/familypackspage_view.dart';
import 'package:foodapp/app/modules/noodelsscreenpage/views/noodelsscreenpage_view.dart';
import 'package:foodapp/app/modules/notificationspage/views/notificationspage_view.dart';
import 'package:foodapp/app/modules/pizzascreenpage/views/pizzascreenpage_view.dart';
import 'package:foodapp/app/modules/productdetailspage/views/productdetailspage_view.dart';
import 'package:foodapp/themes/ThemeController%20.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/home_controller.dart';
import '../../favouritepageview/controllers/favouritepageview_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final favController = Get.put(FavouritepageviewController());
  final themeController = Get.find<ThemeController>();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.apple, 'label': 'Fruits', 'iconColor': Colors.brown},
    {'icon': Icons.grass, 'label': 'Vegetables', 'iconColor': Colors.green},
    {
      'icon': Icons.icecream,
      'label': 'ice Cream',
      'iconColor': Colors.pinkAccent,
    },
    {
      'icon': Icons.local_cafe,
      'label': 'Cones',
      'iconColor': Colors.deepOrange,
    },
    {
      'icon': Icons.bar_chart,
      'label': 'BarsSticks',
      'iconColor': Colors.blueAccent,
    },
    {
      'icon': Icons.family_restroom,
      'label': 'FamilyPacks',
      'iconColor': Colors.teal,
    },
  ];

  final List<String> bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner4.jpg',
    'assets/images/banner2.png',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    // ✅ Breakpoints for responsiveness
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 900;
    final isWeb = width >=600;

    return Scaffold(
      drawer: DrawerView(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
              size: width * 0.07,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: width * 0.045,
              backgroundImage: const AssetImage('assets/images/profile1.jpg'),
            ),
            SizedBox(width: width * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: GoogleFonts.poppins(
                    fontSize: (isWeb ? 18 : width * 0.035) * textScale,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'Food Shop',
                  style: GoogleFonts.poppins(
                    fontSize: (isWeb ? 16 : width * 0.032) * textScale,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: width * 0.07,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => Get.to(() => const AddcartpageviewsView()),
              ),
              Positioned(
                right: width * 0.015,
                top: height * 0.01,
                child: CircleAvatar(
                  radius: width * 0.022,
                  backgroundColor: Colors.red,
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: width * 0.025 * textScale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              size: width * 0.07,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Get.to(() => const NotificationspageView()),
          ),
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
                size: width * 0.07,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () => themeController.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _carouselSlider(context),
              SizedBox(height: height * 0.025),
              _searchBar(context),
              SizedBox(height: height * 0.025),
              _categoryTabs(context),
              SizedBox(height: height * 0.025),
              _sectionHeader(context, 'Popular Items'),
              SizedBox(height: height * 0.015),
              Obx(
                () => _nonScrollableProductGrid(
                  controller.filteredItems,
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Carousel Slider
  Widget _carouselSlider(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.22,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: bannerImages.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
        );
      }).toList(),
    );
  }

  // ✅ Search Bar
  Widget _searchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return TextField(
      onChanged: (value) => controller.updateSearch(value),
      style: GoogleFonts.poppins(fontSize: width * 0.035 * textScale),
      decoration: InputDecoration(
        hintText: 'Search your food...',
        hintStyle: GoogleFonts.poppins(
          fontSize: width * 0.032 * textScale,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
          size: width * 0.06,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.035),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ✅ Category Tabs
  Widget _categoryTabs(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return SizedBox(
      height: height * 0.11,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: width * 0.03),
        itemBuilder: (context, index) {
          final item = categories[index];
          return SizedBox(
            width: width * 0.19,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(width * 0.10),
                onTap: () => _navigateToCategory(item['label']),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: width * 0.075,
                      backgroundColor: Theme.of(context).cardColor,
                      child: Icon(
                        item['icon'],
                        color: item['iconColor'],
                        size: width * 0.07,
                      ),
                    ),
                    SizedBox(height: height * 0.007),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.029 * textScale,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToCategory(String categoryLabel) {
    switch (categoryLabel) {
      case 'Vegetables':
        Get.to(() => PizzascreenpageView());
        break;
      case 'Fruits':
        Get.to(() => BurgerscreenpageView());
        break;
      case 'ice Cream':
        Get.to(() => NoodelsscreenpageView());
        break;
      case 'Cones':
        Get.to(() => ConespagescreenView());
        break;
      case 'BarsSticks':
        Get.to(() => BarsstickspageView());
        break;
      case 'FamilyPacks':
        Get.to(() => FamilypackspageView());
        break;
      default:
        Get.snackbar(
          'Coming Soon',
          '$categoryLabel items will be available soon!',
        );
    }
  }

  // ✅ Section Header
  Widget _sectionHeader(BuildContext context, String title) {
    final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
        ),
        Text(
          "See All",
          style: GoogleFonts.poppins(
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
          ),
        ),
      ],
    );
  }

  // ✅ Responsive Grid
  Widget _nonScrollableProductGrid(
    List<Map<String, String>> items,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
        ? 3
        : 4;

    return AnimationLimiter(
      child: MasonryGridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: screenWidth * 0.035,
        crossAxisSpacing: screenWidth * 0.035,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: crossAxisCount,
            child: ScaleAnimation(
              child: FadeInAnimation(child: _productCard(item, context)),
            ),
          );
        },
      ),
    );
  }

  // ✅ Product Card
  Widget _productCard(Map<String, String> item, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: () => Get.to(
        () => const ProductDetailsViewpageView(),
        arguments: {
          'images': [item['image']],
          'title': item['title'],
          'price': item['price'],
          'oldPrice': item['oldPrice'],
        },
      ),
      child: Container(
        width: screenWidth < 600 ? screenWidth * 0.45 : screenWidth * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(screenWidth * 0.02),
                  ),
                  child: Image.asset(
                    item['image']!,
                    height: screenWidth * 0.38,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.02,
                  top: screenWidth * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenWidth * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.amber : Colors.pink,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Text(
                      'New',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.025 * textScale,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.02,
                  top: screenWidth * 0.02,
                  child: Obx(() {
                    final isFav = favController.isFavourite(item);
                    return GestureDetector(
                      onTap: () => favController.toggleFavourite(item),
                      child: CircleAvatar(
                        radius: screenWidth * 0.045,
                        backgroundColor: isFav
                            ? Colors.pink
                            : Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : const Color.fromARGB(255, 231, 228, 228),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035 * textScale,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Row(
                    children: [
                      Text(
                        item['price']!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.038 * textScale,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        item['oldPrice']!,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032 * textScale,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
