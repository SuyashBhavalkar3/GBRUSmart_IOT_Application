import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';

/// Screen displayed after the ownership transfer request is successfully submitted.
class OwnershipTransferSuccessScreen extends ConsumerWidget {
  const OwnershipTransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Badge: Checkmark inside soft green circle
              Container(
                width: 90.0,
                height: 90.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEBF7F0), // Soft green circle background
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primaryGreen,
                    size: 48.0,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              
              // Bold title
              const Text(
                'Request Submitted',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              
              // Subtitle
              const Text(
                'Your ownership transfer request has been sent to our support team. We will review it and contact you if needed.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Go to Home Button
              PrimaryGradientButton(
                label: 'Go to Home',
                onPressed: () {
                  // Reset provider state and return back to Dashboard
                  ref.read(mobileAutoProvider.notifier).resetFlow();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: 12.0),
              
              // Footer text
              const Text(
                "You'll receive updates via SMS and notifications",
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
