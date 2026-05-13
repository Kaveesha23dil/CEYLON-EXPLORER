import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../screens/onboarding_screen.dart';

/// Ceylon Explorer splash/loading screen.
///
/// Clean white background with the "Ceylon Explore" logo centered.
/// The word "Explore" has a small golden/yellow dot above the letter "E".
/// After a brief delay the screen cross-dissolves to Onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    // Immersive on splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Start the fade-in
    _fadeController.forward();

    // Navigate to onboarding after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), _navigateToOnboarding);
  }

  void _navigateToOnboarding() {
    if (_navigating || !mounted) return;
    _navigating = true;

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // "Ceylon " text
              const Text(
                'Ceylon ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
              // "Explore" with the yellow dot above the "E"
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                  // Yellow dot positioned above the "E"
                  Positioned(
                    top: -8,
                    left: 3,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
