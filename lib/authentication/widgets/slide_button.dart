import 'package:flutter/material.dart';

class SlideButton extends StatefulWidget {
  final VoidCallback? onCompleted;

  const SlideButton({super.key, this.onCompleted});

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  @override
  Widget build(BuildContext context) {
    // The control must include a rounded pill background, circular black icon container,
    // arrow icon, text, right arrow.
    // If the supplied design is only visual, implement it as a tappable button.
    // Easy to upgrade to a draggable slider later.
    return GestureDetector(
      onTap: widget.onCompleted,
      child: Container(
        height: 60, // Approximate to 59.91902160644531
        decoration: BoxDecoration(
          color: const Color(0xFFBFEA7C), // button background color
          borderRadius: BorderRadius.circular(45372000),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              // Circular black icon container
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF171717), // arrow button color
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Slide to Get Started",
                    style: TextStyle(
                      color: Color(0xFF1E4123), // logo color used for text contrast
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Invisible container to balance the text centering
              const SizedBox(width: 52),
            ],
          ),
        ),
      ),
    );
  }
}
