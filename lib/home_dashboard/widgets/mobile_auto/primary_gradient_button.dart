import 'package:flutter/material.dart';
import '../../app_colors.dart';

/// Reusable full-width pill-shaped button used throughout the onboarding journey.
/// Supports a custom background color for rendering orange/warning variants.
class PrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;

  const PrimaryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final active = isEnabled && !isLoading;
    final buttonColor = backgroundColor ?? AppColors.primaryGreen;

    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? buttonColor : AppColors.borderGrey,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: AppColors.borderGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
          elevation: active ? 2 : 0,
          side: active ? borderSide : null,
        ),
        onPressed: active ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: active ? (textColor ?? Colors.white) : AppColors.textGrey,
                ),
              ),
      ),
    );
  }
}
