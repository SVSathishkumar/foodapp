import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/app/modules/aboutscreenpage/controllers/aboutscreenpage_controller.dart';
import 'package:foodapp/app/modules/bottomnavgationbar/views/bottomnavgationbar_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutpageView extends StatefulWidget {
  const AboutpageView({super.key});

  @override
  State<AboutpageView> createState() => _AboutpageViewState();
}

class _AboutpageViewState extends State<AboutpageView>
    with TickerProviderStateMixin {
  double _opacity = 0.0;
  late final AboutpageController controller;
  late YoutubePlayerController _youtubeController;
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

    const videoUrl = "https://youtu.be/npnPpRCX0gw?si=rPCHcFxgANZbFfTn";
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

    // ✅ Responsive font scaling
    final double titleSize = isWeb ? 22 : 18;
    final double sectionTitleSize = isWeb ? 18 : 14;
    final double bodyTextSize = isWeb ? 16 : 13;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
            fontStyle: FontStyle.italic,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.to(() => BottomnavigationbarView());
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 1,
      ),
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
          FadeTransition(
            opacity: _fadeInAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 32 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ YouTube Promo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ✅ Section - Welcome
                      _sectionCard(
                        title: "Welcome to FoodRush!",
                        content:
                            "At FoodRush, we deliver delicious meals from your favorite local restaurants straight to your doorstep. Our platform is fast, reliable, and packed with flavor!",
                        theme: theme,
                        titleSize: sectionTitleSize,
                        bodySize: bodyTextSize,
                      ),
                      const SizedBox(height: 20),

                      // ✅ Section - Mission
                      _sectionCard(
                        title: "Our Mission",
                        content:
                            "To make food delivery quick, affordable, and satisfying for every hunger need.",
                        theme: theme,
                        titleSize: sectionTitleSize,
                        bodySize: bodyTextSize,
                      ),
                      const SizedBox(height: 20),

                      // ✅ Section - Contact
                      _sectionTitle("Get in Touch", theme, sectionTitleSize),
                      const SizedBox(height: 10),
                      _contactText(
                        "Email",
                        "Sathishkumar18@gmail.com",
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
