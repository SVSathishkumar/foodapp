import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/app/modules/aboutscreenpage/controllers/aboutscreenpage_controller.dart';
import 'package:foodapp/app/modules/addcartpageviews/controllers/addcartpageviews_controller.dart';
import 'package:foodapp/app/modules/drawerpage/controllers/drawerpage_controller.dart';
import 'package:foodapp/app/modules/googlepageview/controllers/googlepageview_controller.dart';
import 'package:foodapp/app/modules/notificationspage/controllers/notificationspage_controller.dart';
import 'package:foodapp/app/modules/onboardingscreen/controllers/onboardingscreen_controller.dart';
import 'package:foodapp/app/modules/orderconfrompageview/controllers/orderconfrompageview_controller.dart';
import 'package:foodapp/app/modules/profilescreenpage/controllers/profilescreenpage_controller.dart';
import 'package:foodapp/themes/ThemeController%20.dart';
import 'package:foodapp/themes/app_theme.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/home/controllers/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Register all controllers with GetX
  Get.put(HomeController());
  Get.put(ProfilescreenpageController());
  Get.put(ThemeController());
  Get.put(DrawerpageController());
  Get.put(AddcartpageviewsController());
  Get.put(AboutpageController());
  Get.put(GooglepageviewController());
  Get.put(OrderconfrompageviewController());
  Get.put(NotificationspageController());
  Get.put(OnboardingscreenController());
  Get.put(GooglepageviewController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food App",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.theme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
