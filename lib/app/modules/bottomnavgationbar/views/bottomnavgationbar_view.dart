import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/addcartpageviews/views/addcartpageviews_view.dart';
import 'package:foodapp/app/modules/favouritepageview/views/favouritepageview_view.dart';
import 'package:foodapp/app/modules/googlepageview/views/googlepageview_view.dart';
import 'package:foodapp/app/modules/home/views/home_view.dart';
import 'package:foodapp/app/modules/profilescreenpage/views/profilescreenpage_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomnavigationbarView extends StatefulWidget {
  const BottomnavigationbarView({Key? key}) : super(key: key);

  @override
  _BottomnavigationbarViewState createState() =>
      _BottomnavigationbarViewState();
}

class _BottomnavigationbarViewState extends State<BottomnavigationbarView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    AddcartpageviewsView(),
    FavouritepageviewView(),
    ProfilescreenpageView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ Get screen size
    final isTablet = size.width > 600;
    final isWeb = size.width >800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: _selectedIndex == 3
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.pink,
                  size: isTablet ? 28 : 22, // ✅ Responsive back button size
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Go back to Home tab
                  });
                },
              ),
        automaticallyImplyLeading: false,
        backgroundColor: Get.isDarkMode
            ? const Color.fromARGB(255, 18, 17, 17)
            : Colors.white,
        elevation: 0,

        // Show location icon + text only if Home tab and not Profile tab
        title: (_selectedIndex == 0)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      size: isTablet ? 26 : 19, // ✅ Responsive icon size
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Get.to(GooglepageviewView());
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Text(
                      "623707 Select delivery location",
                      style: GoogleFonts.poppins(
                        fontSize: isWeb
                            ? 16
                            : isTablet
                                ? 14
                                : 11, // ✅ Responsive font
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 201, 202, 202),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),

      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        icons: const [
          Icons.home,
          Icons.shopping_cart,
          Icons.favorite,
          Icons.person,
        ],
        labels: const ['Home', 'Cart', 'Favorite', 'Profile'],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedIconColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.amber.shade200
            : Colors.pink,
        unselectedIconColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 233, 231, 231)
            : const Color.fromARGB(255, 160, 160, 160),
        selectedItemFontStyle: GoogleFonts.raleway(
          fontSize: isWeb
              ? 15
              : isTablet
                  ? 13
                  : 12, // ✅ Responsive font size
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.amber.shade200
              : Colors.pink,
          fontWeight: FontWeight.bold,
        ),
        unselectedItemFontStyle: TextStyle(
          fontSize: isWeb
              ? 14
              : isTablet
                  ? 12
                  : 11, // ✅ Responsive font size
        ),
      ),
    );
  }
}

class CurvedBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<IconData> icons;
  final List<String> labels;
  final Color backgroundColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final TextStyle selectedItemFontStyle;
  final TextStyle unselectedItemFontStyle;

  const CurvedBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.icons,
    required this.labels,
    this.backgroundColor = Colors.white,
    this.selectedIconColor = Colors.black,
    this.unselectedIconColor = Colors.grey,
    this.selectedItemFontStyle = const TextStyle(),
    this.unselectedItemFontStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ Responsive bottom nav
    final isTablet = size.width > 600;
    final isWeb = size.width > 1000;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isWeb
            ? 20
            : isTablet
                ? 16
                : 12, // ✅ Responsive padding
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  size: isWeb
                      ? 32
                      : isTablet
                          ? 28
                          : 22, // ✅ Responsive icon size
                  color: isSelected ? selectedIconColor : unselectedIconColor,
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: isSelected
                      ? selectedItemFontStyle
                      : unselectedItemFontStyle,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
