import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'star_delta_timer_provider.dart';

class StarDeltaTimerScreen extends ConsumerWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSaveSettings;

  const StarDeltaTimerScreen({
    super.key,
    this.onBackPressed,
    this.onSaveSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(starDeltaTimerProvider);
    final timerNotifier = ref.read(starDeltaTimerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final double width = constraints.maxWidth;
            // Base logical size based on typical design (e.g. 393 width)
            final double scale = width / 393.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // --- App Bar ---
                      Padding(
                        padding: EdgeInsets.fromLTRB(24 * scale, 24 * scale, 24 * scale, 16 * scale),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBackButton(scale),
                            SizedBox(width: 16 * scale),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Star-Delta Timer',
                                    style: TextStyle(
                                      fontSize: 20 * scale,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF111827),
                                      fontFamily: 'Inter',
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 4 * scale),
                                  Text(
                                    'Set the timer',
                                    style: TextStyle(
                                      fontSize: 14 * scale,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16 * scale),

                      // --- Main Card ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.0392),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20 * scale),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10 * scale),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3E8FF), // Light purple bg
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomPaint(
                                      size: Size(24 * scale, 24 * scale),
                                      painter: SwitchDelayIconPainter(color: const Color(0xFF9810FA)),
                                    ),
                                  ),
                                  SizedBox(width: 12 * scale),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Switch Delay',
                                          style: TextStyle(
                                            fontSize: 16 * scale,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF111827),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        SizedBox(height: 4 * scale),
                                        Text(
                                          'This is the time the motor runs\nin Star mode before switching\nto Delta mode.',
                                          style: TextStyle(
                                            fontSize: 13 * scale,
                                            color: const Color(0xFF6B7280),
                                            fontFamily: 'Inter',
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 24 * scale),

                              // Timer Selector Container
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(16 * scale),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 24 * scale, horizontal: 16 * scale),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Minus Button
                                        _buildRoundButton(
                                          icon: Icons.remove,
                                          onTap: timerState.timerValue > StarDeltaTimerNotifier.minTimer
                                              ? timerNotifier.decrementTimer
                                              : null,
                                          scale: scale,
                                        ),
                                        
                                        // Timer Display
                                        Column(
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 200),
                                              transitionBuilder: (Widget child, Animation<double> animation) {
                                                return ScaleTransition(scale: animation, child: child);
                                              },
                                              child: Text(
                                                '${timerState.timerValue}',
                                                key: ValueKey<int>(timerState.timerValue),
                                                style: TextStyle(
                                                  fontSize: 48 * scale,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF00A63E),
                                                  fontFamily: 'Inter',
                                                  height: 1.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4 * scale),
                                            Text(
                                              'seconds',
                                              style: TextStyle(
                                                fontSize: 14 * scale,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF4B5563),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Plus Button
                                        _buildRoundButton(
                                          icon: Icons.add,
                                          onTap: timerState.timerValue < StarDeltaTimerNotifier.maxTimer
                                              ? timerNotifier.incrementTimer
                                              : null,
                                          scale: scale,
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 24 * scale),
                                    
                                    // Range indicator
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8 * scale),
                                        border: Border.all(color: const Color(0xFFE5E7EB)),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Range: ',
                                          style: TextStyle(
                                            fontSize: 12 * scale,
                                            color: const Color(0xFF6B7280),
                                            fontFamily: 'Inter',
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '5 - 60 seconds',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF374151),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 24 * scale),
                              
                              // Quick Presets
                              Text(
                                'Quick presets:',
                                style: TextStyle(
                                  fontSize: 13 * scale,
                                  color: const Color(0xFF6B7280),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 12 * scale),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildPresetChip(10, timerState.selectedPreset == 10, timerNotifier, scale),
                                  _buildPresetChip(20, timerState.selectedPreset == 20, timerNotifier, scale),
                                  _buildPresetChip(30, timerState.selectedPreset == 30, timerNotifier, scale),
                                  _buildPresetChip(45, timerState.selectedPreset == 45, timerNotifier, scale),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16 * scale),
                      
                      // --- Configuration Card ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16 * scale),
                            border: Border.all(color: const Color(0xFFC6F6D5)), // light green border
                          ),
                          padding: EdgeInsets.all(20 * scale),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4 * scale),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00A63E),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16 * scale,
                                ),
                              ),
                              SizedBox(width: 12 * scale),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Configuration',
                                      style: TextStyle(
                                        fontSize: 16 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF111827),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Star mode duration: ',
                                        style: TextStyle(
                                          fontSize: 13 * scale,
                                          color: const Color(0xFF4B5563),
                                          fontFamily: 'Inter',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${timerState.timerValue} seconds',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF00A63E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4 * scale),
                                    Text(
                                      'Motor will automatically switch to\nDelta mode after this delay.',
                                      style: TextStyle(
                                        fontSize: 13 * scale,
                                        color: const Color(0xFF6B7280),
                                        fontFamily: 'Inter',
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // --- Bottom Section ---
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(24 * scale, 16 * scale, 24 * scale, 24 * scale),
                        child: Column(
                          children: [
                            // Save Settings Button
                            Container(
                              width: double.infinity,
                              height: 52 * scale,
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
                                  onTap: timerState.isLoading
                                      ? null
                                      : () {
                                          timerNotifier.saveSettings(() {
                                            _showSuccessPopup(context);
                                            if (onSaveSettings != null) {
                                              onSaveSettings!();
                                            }
                                          });
                                        },
                                  child: Center(
                                    child: timerState.isLoading
                                        ? SizedBox(
                                            width: 24 * scale,
                                            height: 24 * scale,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Save Settings',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 * scale,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16 * scale),
                            
                            // Helper Text
                            Text(
                              'Device configuration will be updated after saving.',
                              style: TextStyle(
                                fontSize: 12 * scale,
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(double scale) {
    return Container(
      width: 44 * scale,
      height: 44 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onBackPressed,
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF111827),
              size: 20 * scale,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback? onTap,
    required double scale,
  }) {
    final bool isEnabled = onTap != null;
    return Container(
      width: 40 * scale,
      height: 60 * scale,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.0510),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: Border.all(
          color: isEnabled ? Colors.transparent : const Color(0xFFE5E7EB),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20 * scale),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: isEnabled ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
              size: 24 * scale,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(int seconds, bool isSelected, StarDeltaTimerNotifier notifier, double scale) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4 * scale),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44 * scale,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A63E).withValues(alpha: 0.1020) : Colors.white,
            borderRadius: BorderRadius.circular(8 * scale),
            border: Border.all(
              color: isSelected ? const Color(0xFF00A63E) : const Color(0xFFE5E7EB),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8 * scale),
              onTap: () => notifier.setPreset(seconds),
              child: Center(
                child: Text(
                  '${seconds}s',
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF00A63E) : const Color(0xFF4B5563),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

OverlayEntry? _currentSuccessPopup;

void _showSuccessPopup(BuildContext context) {
  _currentSuccessPopup?.remove();
  _currentSuccessPopup = null;

  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _TopSuccessPopup(
      onDismissed: () {
        if (_currentSuccessPopup == overlayEntry) {
          overlayEntry.remove();
          _currentSuccessPopup = null;
        }
      },
    ),
  );

  _currentSuccessPopup = overlayEntry;
  overlay.insert(overlayEntry);
}

class _TopSuccessPopup extends ConsumerStatefulWidget {
  final VoidCallback onDismissed;

  const _TopSuccessPopup({required this.onDismissed});

  @override
  ConsumerState<_TopSuccessPopup> createState() => _TopSuccessPopupState();
}

class _TopSuccessPopupState extends ConsumerState<_TopSuccessPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      await _controller.reverse();
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read directly from Riverpod as requested
    final timerState = ref.watch(starDeltaTimerProvider);
    
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF00A63E), // Existing primary green color
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1490),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2510),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Star-Delta timer\nupdated successfully',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Switch delay set to ${timerState.timerValue} seconds',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchDelayIconPainter extends CustomPainter {
  final Color color;
  SwitchDelayIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.09
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final topCircleCenter = Offset(size.width * 0.35, size.height * 0.25);
    final bottomCircleCenter = Offset(size.width * 0.8, size.height * 0.75);
    final radius = size.width * 0.18;

    // Top Circle
    canvas.drawCircle(topCircleCenter, radius, paint);

    // Bottom Circle
    canvas.drawCircle(bottomCircleCenter, radius, paint);

    // Vertical line
    canvas.drawLine(
      Offset(topCircleCenter.dx, topCircleCenter.dy + radius),
      Offset(topCircleCenter.dx, size.height * 0.95),
      paint,
    );

    // Curved line branching off
    final path = Path();
    final startY = size.height * 0.55;
    path.moveTo(topCircleCenter.dx, startY);
    path.quadraticBezierTo(
      topCircleCenter.dx, bottomCircleCenter.dy, // Control point
      bottomCircleCenter.dx - radius, bottomCircleCenter.dy,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
