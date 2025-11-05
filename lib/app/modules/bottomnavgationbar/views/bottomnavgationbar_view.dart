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

  bool get isDark => Theme.of(Get.context!).brightness == Brightness.dark;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false; // prevent exiting app
    }
    return true; // exit app when on Home tab
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Get.isDarkMode
              ? Color.fromARGB(255, 18, 17, 17)
              : Colors.white,
          elevation: 0,
          title: (_selectedIndex == 0)
              ? Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.location_on,
                        size: width * 0.050,
                        color: isDark
                            ? Colors.pink
                            : const Color.fromARGB(255, 250, 209, 84),
                      ),
                      onPressed: () {
                        Get.to(GooglepageviewView());
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 1),
                    Expanded(
                      child: Text(
                        "623707 Select delivery location",
                        style: GoogleFonts.poppins(
                          fontSize: width * 0.032 * textScale,
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
            fontSize: width * 0.035 * textScale,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.amber.shade200
                : Colors.pink,
            fontWeight: FontWeight.bold,
          ),
          unselectedItemFontStyle: TextStyle(
            fontSize: width * 0.032 * textScale,
          ),
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
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.symmetric(vertical: width * 0.03),
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
                  size: width * 0.07,
                  color: isSelected ? selectedIconColor : unselectedIconColor,
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: isSelected
                      ? selectedItemFontStyle.copyWith(
                          fontSize: width * 0.035 * textScale,
                        )
                      : unselectedItemFontStyle.copyWith(
                          fontSize: width * 0.032 * textScale,
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
