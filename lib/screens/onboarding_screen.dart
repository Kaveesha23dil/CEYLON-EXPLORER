import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Data model for each onboarding page.
class _OnboardingPage {
  final String title;
  final String subtitle;
  final String imagePath;
  final String buttonText;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttonText,
  });
}

/// 3-page onboarding screen matching the Figma design.
///
/// Layout per page (top → bottom):
///   1. Safe area top padding
///   2. Bold teal title — left-aligned, large
///   3. Gray subtitle — left-aligned, smaller
///   4. Illustration image — fills the remaining vertical space,
///      with its natural light sky blending into the white background
///   5. Teal pill button overlaid at the very bottom of the image
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Explore\nthe Beauty\nof Sri Lanka',
      subtitle: 'Discover beaches, mountains, and hidden gems.',
      imagePath: 'assets/images/onboarding_1.png',
      buttonText: 'Get Started',
    ),
    _OnboardingPage(
      title: 'Adventure\nAwaits in Every\nCorner',
      subtitle: 'Enjoy scenic rides, wildlife, and nature.',
      imagePath: 'assets/images/onboarding_2.png',
      buttonText: 'Next',
    ),
    _OnboardingPage(
      title: 'Plan Your\nPerfect Journey',
      subtitle: 'Save places and travel with ease.',
      imagePath: 'assets/images/onboarding_3.png',
      buttonText: 'Start Exploring',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Restore system UI on onboarding
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page — navigate to home or main screen
      // TODO: Navigate to the main app screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildPage(_pages[index]);
        },
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: AppColors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Image ──
          Image.asset(
            page.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),

          // ── Content overlaid on image ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top section: Title + Subtitle ──
              Padding(
                padding: EdgeInsets.only(
                  top: topPadding + 60,
                  left: 28,
                  right: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(
                            text: '${page.title.split('\n').first}\n',
                            style: const TextStyle(color: Color(0xFFD4A017)),
                          ),
                          TextSpan(
                            text: page.title.split('\n').skip(1).join('\n'),
                            style: const TextStyle(color: Color(0xFF0F7A6B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    Text(
                      page.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── CTA Button anchored at the bottom ──
              Padding(
                padding: EdgeInsets.only(
                  bottom: bottomPadding > 0 ? bottomPadding + 24 : 48,
                ),
                child: Center(
                  child: _buildActionButton(page.buttonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Teal pill button with text + forward arrow.
  Widget _buildActionButton(String text) {
    return GestureDetector(
      onTap: _onNextPressed,
      child: Container(
        width: 260,
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
