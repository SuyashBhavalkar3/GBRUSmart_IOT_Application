import 'package:flutter/material.dart';
import 'widgets/slide_button.dart';

// TODO: If the logo provided is an SVG, add flutter_svg dependency to pubspec.yaml
// and import 'package:flutter_svg/flutter_svg.dart'; here. Do not modify pubspec.yaml 
// directly as per constraints.

class SplashScreen extends StatefulWidget {
  final VoidCallback? onGetStarted;

  const SplashScreen({super.key, this.onGetStarted});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Smooth logo fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Smooth bottom button fade up
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          // TODO: Update the asset path to the actual background image provided
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover, // Cover entire screen, no distortion
          ),

          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Logo Section
                    Expanded(
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: FractionallySizedBox(
                            widthFactor: 0.5, // Scale logo proportionally to screen
                            // TODO: Replace with actual logo asset path
                            // If SVG: SvgPicture.asset('assets/logo.svg')
                            child: const Placeholder(
                              fallbackHeight: 100,
                              color: Color(0xFF1E4123), // Logo color constraint
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Bottom Button Section
                    Padding(
                      // Calculate bottom padding proportionally based on Figma frame size (852 total height, button at 754 top, 60 height)
                      // Leaves approx ~38 pixels from the bottom of the safe area.
                      padding: EdgeInsets.only(
                        bottom: constraints.maxHeight * (38.0 / 852.0),
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation, // Fade up animation combined
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FractionallySizedBox(
                            // Maintain design width proportions: 326 / 393
                            widthFactor: 326.0 / 393.0,
                            child: SlideButton(
                              onCompleted: widget.onGetStarted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
