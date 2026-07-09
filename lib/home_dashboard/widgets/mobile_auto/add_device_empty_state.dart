import 'package:flutter/material.dart';
import '../../app_colors.dart';
import 'primary_gradient_button.dart';

/// Reusable empty-state widget for device screens and onboarding steps.
class AddDeviceEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onButtonPressed;

  const AddDeviceEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Grey circular background with phone/device outline icon
          Container(
            width: 96.0,
            height: 96.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.borderGrey.withAlpha(102),
            ),
            child: const Center(
              child: Icon(
                Icons.phone_android_outlined,
                size: 48.0,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          // Bold heading
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          // Grey subtext
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14.0,
              color: AppColors.textGrey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48.0),
          // Call-to-action button
          PrimaryGradientButton(
            label: buttonLabel,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }
}
