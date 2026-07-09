import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/onboarding_stepper.dart';
import '../../widgets/mobile_auto/otp_input_boxes.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import 'device_added_success_screen.dart';
import 'ownership_transfer_request_screen.dart';

/// Screen 6: Final OTP confirmation for Step 3 Approval.
class ConfirmOtpStep3Screen extends ConsumerStatefulWidget {
  const ConfirmOtpStep3Screen({super.key});

  @override
  ConsumerState<ConfirmOtpStep3Screen> createState() => _ConfirmOtpStep3ScreenState();
}

class _ConfirmOtpStep3ScreenState extends ConsumerState<ConfirmOtpStep3Screen> {
  String _enteredOtp = '';

  void _onContactSupport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OwnershipTransferRequestScreen(),
      ),
    );
  }

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
          'Confirm Device Addition',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper is active on Step 3 (Approval)
            const OnboardingStepper(currentStep: 3),
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
                        notifier.setOtpStep3(otp);
                      },
                      onCompleted: (otp) {
                        setState(() {
                          _enteredOtp = otp;
                        });
                        notifier.setOtpStep3(otp);
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
                    
                    // Didn't receive OTP? Contact Support
                    Center(
                      child: GestureDetector(
                        onTap: _onContactSupport,
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
                      const SizedBox(height: 24.0),
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
            
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryGradientButton(
                label: 'Verify & Continue',
                isEnabled: _enteredOtp.length == 6,
                isLoading: onboardingState.isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final verified = await notifier.verifyStep3Otp();
                  if (verified) {
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const DeviceAddedSuccessScreen(),
                      ),
                      (route) => route.isFirst,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
