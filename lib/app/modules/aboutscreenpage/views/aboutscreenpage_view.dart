import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/aboutscreenpage/controllers/aboutscreenpage_controller.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutpageView extends StatefulWidget {
  const AboutpageView({super.key});

  @override
  State<AboutpageView> createState() => _AboutpageViewState();
}

class _AboutpageViewState extends State<AboutpageView>
    with TickerProviderStateMixin {
  double _opacity = 0.0;
  late final AboutpageController controller;
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AboutpageController>();

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
      _fadeInController.forward();
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

    // ✅ Detect dark mode
    final bool isDark = theme.brightness == Brightness.dark;

    // ✅ Responsive font scaling
    final double titleSize = isWeb ? 22 : 18;
    final double sectionTitleSize = isWeb ? 18 : 14;
    final double bodyTextSize = isWeb ? 16 : 13;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            // ✅ Background image with fade zoom animation
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 8),
                tween: Tween(begin: 1.0, end: 1.1),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.asset(
                        "assets/images/aboutpage.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ✅ Custom back button (no AppBar)
            Positioned(
              top: 16,
              left: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Get.to(BottomnavigationbarView()),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromARGB(255, 248, 211, 99)
                          : Colors.pink, // ✅ fixed
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset:  Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Main Content
            FadeTransition(
              opacity: _fadeInAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isWeb ? 32 : 16,
                  70,
                  isWeb ? 32 : 16,
                  16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 800 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionCard(
                          title: "Welcome to SKN Hostel Nagekovi!",
                          content:
                              "At SKN Hostel Nagekovi, we ensure your stay is comfortable, secure, and enjoyable. Our services are designed to provide students and residents with the best living experience possible.",
                          theme: theme,
                          titleSize: sectionTitleSize,
                          bodySize: bodyTextSize,
                        ),
                        const SizedBox(height: 20),
                        _sectionCard(
                          title: "Our Mission",
                          content:
                              "To provide a safe, affordable, and friendly hostel environment for every student and resident.",
                          theme: theme,
                          titleSize: sectionTitleSize,
                          bodySize: bodyTextSize,
                        ),
                        const SizedBox(height: 20),
                        _sectionCard(
                          title: "Estimated Cooking Time (ECT)",
                          content:
                              "We value your time! Each meal order from our hostel kitchen comes with a real-time Estimated Cooking Time (ECT), so you’ll always know when your food will be ready.",
                          theme: theme,
                          titleSize: sectionTitleSize,
                          bodySize: bodyTextSize,
                        ),
                        const SizedBox(height: 46),
                        _sectionTitle("Get in Touch", theme, sectionTitleSize),
                        const SizedBox(height: 10),
                        _contactText(
                          "Email",
                          "SKN18@gmail.com",
                          recognizer: controller.emailRecognizer,
                          theme: theme,
                          bodySize: bodyTextSize,
                        ),
                        const SizedBox(height: 15),
                        _contactText(
                          "Phone",
                          "+91 93451 31081",
                          recognizer: controller.phoneRecognizer,
                          theme: theme,
                          bodySize: bodyTextSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Title Section
  Widget _sectionTitle(String text, ThemeData theme, double fontSize) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.titleLarge?.color,
      ),
    );
  }

  // ✅ Card Section
  Widget _sectionCard({
    required String title,
    required String content,
    required ThemeData theme,
    required double titleSize,
    required double bodySize,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: titleSize,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: bodySize,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Contact Info Text
  Widget _contactText(
    String label,
    String value, {
    required TapGestureRecognizer recognizer,
    required ThemeData theme,
    required double bodySize,
  }) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: bodySize),
        children: [
          TextSpan(
            text: "$label: ",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: bodySize,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontSize: bodySize,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: recognizer,
          ),
        ],
      ),
    );
  }
}
