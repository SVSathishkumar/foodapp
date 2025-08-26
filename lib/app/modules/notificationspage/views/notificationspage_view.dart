import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notificationspage_controller.dart';

class NotificationspageView extends StatefulWidget {
  const NotificationspageView({super.key});

  @override
  State<NotificationspageView> createState() => _NotificationspageViewState();
}

class _NotificationspageViewState extends State<NotificationspageView>
    with SingleTickerProviderStateMixin {
  final NotificationspageController controller = Get.put(
    NotificationspageController(),
  );

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color.fromARGB(255, 241, 202, 84) : Colors.pink,
            size: width * 0.06, // responsive back arrow size
          ),
          onPressed: () => Get.to(const BottomnavigationbarView()),
        ),
        centerTitle: true,
        title: Text(
          "Notification",
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
            fontSize: width * 0.045, // responsive title size
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.17,
              child: Image.asset(
                "assets/images/notificationsssssssss.png",
                fit: BoxFit.cover,
                height: height * 0.35, // responsive background image
              ),
            ),
          ),

          // Main Content with Animation
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.04),
                    _buildSwitchTile(
                      context: context,
                      title: "Allow Notifications",
                      description:
                          "Lorem ipsum dolor sit amet, consectetur sadi pscing elit, sed diam nonummy",
                      value: controller.allowNotifications,
                    ),
                    SizedBox(height: height * 0.04),
                    _buildSwitchTile(
                      context: context,
                      title: "Email Notifications",
                      description:
                          "Lorem ipsum dolor sit amet, consectetur sadi pscing elit, sed diam nonummy",
                      value: controller.emailNotifications,
                    ),
                    SizedBox(height: height * 0.04),
                    _buildSwitchTile(
                      context: context,
                      title: "Order Notifications",
                      description:
                          "Lorem ipsum dolor sit amet, consectetur sadi pscing elit, sed diam nonummy",
                      value: controller.orderNotifications,
                    ),
                    SizedBox(height: height * 0.04),
                    _buildSwitchTile(
                      context: context,
                      title: "General Notifications",
                      description:
                          "Lorem ipsum dolor sit amet, consectetur sadi pscing elit, sed diam nonummy",
                      value: controller.generalNotifications,
                    ),
                    const Spacer(),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String description,
    required RxBool value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.04, // responsive title size
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.032, // responsive description
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value.value,
              activeColor: isDark
                  ? const Color.fromARGB(255, 237, 200, 87)
                  : Colors.pink,
              onChanged: (val) => value.value = val,
            ),
          ],
        ),
      ),
    );
  }
}
