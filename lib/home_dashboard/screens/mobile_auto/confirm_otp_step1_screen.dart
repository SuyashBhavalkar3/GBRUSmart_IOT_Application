import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/onboarding_stepper.dart';
import '../../widgets/mobile_auto/otp_input_boxes.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import 'verify_number_step2_screen.dart';
import 'ownership_transfer_request_screen.dart';

/// Screen 4: OTP confirmation for Step 1.
class ConfirmOtpStep1Screen extends ConsumerStatefulWidget {
  final String buttonLabel;
  final bool showSecurityNote;

  const ConfirmOtpStep1Screen({
    super.key,
    this.buttonLabel = 'Continue',
    this.showSecurityNote = false,
  });

  @override
  ConsumerState<ConfirmOtpStep1Screen> createState() => _ConfirmOtpStep1ScreenState();
}

class _ConfirmOtpStep1ScreenState extends ConsumerState<ConfirmOtpStep1Screen> {
  String _enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(mobileAutoProvider);
    final notifier = ref.read(mobileAutoProvider.notifier);

    final secondsRemaining = onboardingState.resendSecondsRemaining;
    final isTimerActive = secondsRemaining > 0;
    
    // Format timer display, e.g., 00:44
    final timerString = '00:${secondsRemaining.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Mobile Auto Unit 1',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper is still active on Step 1
            const OnboardingStepper(currentStep: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm Device Addition',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      "We've sent a 6-digit verification code to your registered mobile number.",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    
                    // OTP Input Fields Widget
                    OtpInputBoxes(
                      onChanged: (otp) {
                        setState(() {
                          _enteredOtp = otp;
                        });
                        notifier.setOtpStep1(otp);
                      },
                      onCompleted: (otp) {
                        setState(() {
                          _enteredOtp = otp;
                        });
                        notifier.setOtpStep1(otp);
                      },
                    ),
                    const SizedBox(height: 24.0),
                    
                    // Countdown and Resend Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isTimerActive) ...[
                          Text(
                            'Resend OTP in ',
                            style: TextStyle(color: AppColors.textGrey, fontSize: 14.0),
                          ),
                          Text(
                            timerString,
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ] else ...[
                          Text(
                            "Didn't receive code? ",
                            style: TextStyle(color: AppColors.textGrey, fontSize: 14.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              notifier.startResendTimer();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP sent successfully!'),
                                  backgroundColor: AppColors.primaryGreen,
                                ),
                              );
                            },
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const OwnershipTransferRequestScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Didn't receive OTP? Contact Support",
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    if (onboardingState.errorMessage != null) ...[
                      const SizedBox(height: 20.0),
                      Center(
                        child: Text(
                          onboardingState.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    label: widget.buttonLabel,
                    isEnabled: _enteredOtp.length == 6,
                    isLoading: onboardingState.isLoading,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final verified = await notifier.verifyStep1Otp();
                      if (verified) {
                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) => const VerifyNumberStep2Screen(),
                          ),
                        );
                      }
                    },
                  ),
                  if (widget.showSecurityNote) ...[
                    const SizedBox(height: 12.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 14.0, color: AppColors.textGrey),
                        SizedBox(width: 6.0),
                        Text(
                          'Your data is encrypted and secure',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
