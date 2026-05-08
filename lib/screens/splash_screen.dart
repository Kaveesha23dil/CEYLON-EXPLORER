import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../painters/topo_pattern_painter.dart';
import '../painters/sri_lanka_logo_painter.dart';
import '../painters/loading_arc_painter.dart';
import '../screens/onboarding_screen.dart';

/// Ceylon Explorer splash/loading screen.
///
/// Implements a carefully choreographed animation sequence:
///   0.0–0.4s  Black → dark navy fade-in
///   0.4–1.0s  Logo scales 0.6→1.0 (ease-out) + golden glow pulse
///   1.0–1.6s  App name slides up 12px + fades in
///   1.6–2.0s  Tagline fades in
///   2.0s+     Circular loading arc begins spinning
///   On complete: Cross-dissolve to Onboarding (300ms)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation Controllers ──
  late AnimationController _sequenceController; // drives the 0→2s intro
  late AnimationController _loadingController;  // infinite spin for arc
  late AnimationController _fadeOutController;  // cross-dissolve exit

  // ── Derived Animations ──
  late Animation<double> _bgFade;          // 0.0–0.4s
  late Animation<double> _logoScale;       // 0.4–1.0s
  late Animation<double> _logoGlow;        // 0.4–1.0s
  late Animation<double> _nameOpacity;     // 1.0–1.6s
  late Animation<double> _nameSlide;       // 1.0–1.6s
  late Animation<double> _taglineOpacity;  // 1.6–2.0s
  late Animation<double> _loadingOpacity;  // 2.0–2.2s (quick fade-in)
  late Animation<double> _fadeOut;         // exit transition

  bool _loadingStarted = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    // Hide status bar on splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // ── Sequence Controller (2.2s total) ──
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Frame 0–0.4s: Background fade from black to navy
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.18, curve: Curves.easeIn), // 0–0.4s of 2.2s
      ),
    );

    // Frame 0.4–1.0s: Logo scale 0.6 → 1.0
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.18, 0.45, curve: Curves.easeOut), // 0.4–1.0s
      ),
    );

    // Frame 0.4–1.0s: Golden glow pulse (0 → 1 → 0.6)
    _logoGlow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 40),
    ]).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.18, 0.45, curve: Curves.easeOut),
      ),
    );

    // Frame 1.0–1.6s: Name slide up 12px + fade in
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.45, 0.73, curve: Curves.easeOut), // 1.0–1.6s
      ),
    );
    _nameSlide = Tween<double>(begin: 12.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.45, 0.73, curve: Curves.easeOut),
      ),
    );

    // Frame 1.6–2.0s: Tagline fade in
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.73, 0.91, curve: Curves.easeIn), // 1.6–2.0s
      ),
    );

    // Frame 2.0–2.2s: Loading indicator fade in
    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.91, 1.0, curve: Curves.easeIn),
      ),
    );

    // ── Loading Arc Spinner ──
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // ── Fade Out Controller (300ms cross-dissolve) ──
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );

    // Start the sequence
    _sequenceController.forward();

    // When loading indicator appears, start spinning
    _sequenceController.addListener(() {
      if (_sequenceController.value >= 0.91 && !_loadingStarted) {
        _loadingStarted = true;
        _loadingController.repeat();
      }
    });

    // Simulate load completion after 4.5s total
    Future.delayed(const Duration(milliseconds: 4500), () {
      _onLoadComplete();
    });
  }

  void _onLoadComplete() {
    if (_navigating || !mounted) return;
    _navigating = true;

    _fadeOutController.forward().then((_) {
      if (!mounted) return;
      // Restore system UI
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    _loadingController.dispose();
    _fadeOutController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _sequenceController,
        _loadingController,
        _fadeOutController,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeOut.value,
          child: Scaffold(
            backgroundColor: AppColors.black,
            body: Stack(
              children: [
                // ── Background: dark navy fade-in ──
                Opacity(
                  opacity: _bgFade.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                    ),
                  ),
                ),

                // ── Topographic wave pattern overlay ──
                Opacity(
                  opacity: _bgFade.value,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: TopoPatternPainter(opacity: 0.06),
                  ),
                ),

                // ── Centered content ──
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Logo ──
                        Transform.scale(
                          scale: _logoScale.value,
                          child: Semantics(
                            label: 'Ceylon Explorer logo — Sri Lanka island silhouette with golden lotus flower',
                            image: true,
                            child: SizedBox(
                              width: 180,
                              height: 200,
                              child: CustomPaint(
                                painter: SriLankaLogoPainter(
                                  glowIntensity: _logoGlow.value,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── App Name ──
                        Transform.translate(
                          offset: Offset(0, _nameSlide.value),
                          child: Opacity(
                            opacity: _nameOpacity.value,
                            child: const Text(
                              'CEYLON EXPLORER',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                                letterSpacing: 4,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Tagline ──
                        Opacity(
                          opacity: _taglineOpacity.value,
                          child: const Text(
                            'Discover the Pearl of the Indian Ocean',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: AppColors.taglineWhite,
                              letterSpacing: 1.2,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Loading Arc ──
                        Opacity(
                          opacity: _loadingOpacity.value,
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CustomPaint(
                              painter: LoadingArcPainter(
                                progress: _loadingController.value,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
