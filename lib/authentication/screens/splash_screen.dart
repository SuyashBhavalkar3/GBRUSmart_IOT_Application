import 'package:flutter/material.dart';
import '../widgets/slide_button.dart';

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
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
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
          Image.asset(
            'assets/authentication_assets/background.jpg',
            fit: BoxFit.cover, // Cover entire screen, no distortion
          ),

          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;
                return Stack(
                  children: [
                    // Unified Logo Section
                    Positioned(
                      top: height * (210.0 / 852.0),
                      left: 0,
                      right: 0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 'Smart' Text, offset from the top of the GBRU turban
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * (25.9 / 852.0),
                                  ), // 235.9 - 210.0 = 25.9
                                  child: Text(
                                    'Smart',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: width * (44.0 / 393.0),
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF1E4123),
                                      height: 1.0,
                                      letterSpacing:
                                          -1.0, // Tight kerning to match brand design
                                    ),
                                  ),
                                ),

                                // Explicit spacing to push GBRU away from 't'
                                SizedBox(width: width * (5.0 / 393.0)),

                                // 'GBRU' Image
                                Image.asset(
                                  'assets/authentication_assets/download.png',
                                  height: height * (86.416 / 852.0),
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),

                            // Subtitle Section
                            Transform.translate(
                              // Offset subtitle to exact design coords
                              offset: Offset(0, height * (-8.816 / 852.0)),
                              child: Text(
                                'STRONG | SMART | SUPERIOR',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize:
                                      width *
                                      (10.0 /
                                          393.0), // Decreased from 14.0 for consistency
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: const Color(0xFF1E4123),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Button Section
                    Positioned(
                      bottom: height * (38.0 / 852.0),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FractionallySizedBox(
                              widthFactor: 326.0 / 393.0,
                              child: SlideButton(
                                onCompleted: widget.onGetStarted,
                              ),
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
