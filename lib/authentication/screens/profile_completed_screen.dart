import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCompletedScreen extends StatefulWidget {
  final VoidCallback? onGoToHome;

  const ProfileCompletedScreen({
    super.key,
    this.onGoToHome,
  });

  @override
  State<ProfileCompletedScreen> createState() => _ProfileCompletedScreenState();
}

class _ProfileCompletedScreenState extends State<ProfileCompletedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
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
      backgroundColor: const Color(0xFFF1FDF6), // Same background as Login Screen
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final double width = constraints.maxWidth;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width * (24.0 / 393.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Success Circle
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: width * (120.0 / 393.0),
                      height: width * (120.0 / 393.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00A63E), // Primary green
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.black,
                          size: width * (60.0 / 393.0),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: height * (40.0 / 852.0)),
                  
                  // Animated Text
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Profile Completed!',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: width * (22.0 / 393.0),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                            height: 28.0 / 22.0, // line-height: 28px / font-size: 22px
                            letterSpacing: 0,
                          ),
                        ),
                        
                        SizedBox(height: height * (16.0 / 852.0)),
                        
                        Text(
                          'Your profile has been successfully updated.\nYou are all set to explore the app.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: width * (14.0 / 393.0),
                            color: const Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: height * (40.0 / 852.0)),
                  
                  // Go to Home Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      height: height * (52.0 / 852.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00A63E), Color(0xFF008236)],
                          stops: [0.3026, 1.0],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: widget.onGoToHome,
                          child: Center(
                            child: Text(
                              'Go to Home',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: width * (16.0 / 393.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
