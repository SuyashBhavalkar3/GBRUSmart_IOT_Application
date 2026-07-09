import 'package:flutter/material.dart';

class SlideButton extends StatefulWidget {
  final VoidCallback? onCompleted;

  const SlideButton({super.key, this.onCompleted});

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  double _dragFraction = 0.0;
  bool _isCompleted = false;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 60.0;
    const double sliderSize = 52.0;
    const double padding = 4.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        // The maximum distance the thumb can travel horizontally
        final double maxDragDistance = maxWidth - sliderSize - (padding * 2);

        return Container(
          height: buttonHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFBFEA7C), // button background color
            borderRadius: BorderRadius.circular(45372000), // high border radius for pill shape
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Centered Text
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: sliderSize / 2), // Optical centering
                  child: const Text(
                    "Slide to Get Started",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF1E4123), // logo color used for text contrast
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Draggable Button Thumbnail
              AnimatedPositioned(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: padding + (_dragFraction * maxDragDistance),
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    if (_isCompleted) return;
                    setState(() => _isDragging = true);
                  },
                  onHorizontalDragUpdate: (details) {
                    if (_isCompleted) return;
                    setState(() {
                      // Calculate what fraction of the max distance was dragged
                      _dragFraction += details.delta.dx / maxDragDistance;
                      _dragFraction = _dragFraction.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isCompleted) return;
                    setState(() => _isDragging = false);
                    
                    // If dragged more than 80%, complete the slide
                    if (_dragFraction > 0.8) {
                      setState(() {
                        _dragFraction = 1.0;
                        _isCompleted = true;
                      });
                      if (widget.onCompleted != null) {
                        // Delay slightly so user sees it reach the end before navigating
                        Future.delayed(const Duration(milliseconds: 150), () {
                          widget.onCompleted!();
                        });
                      }
                    } else {
                      // Otherwise, smoothly snap back to start
                      setState(() {
                        _dragFraction = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: sliderSize,
                    height: sliderSize,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
