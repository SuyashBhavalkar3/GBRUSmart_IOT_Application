import 'package:flutter/material.dart';
import '../providers/otp_provider.dart';
import '../widgets/otp_input.dart';
import 'complete_profile_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onBackPressed;
  final VoidCallback? onChangeNumber;
  final VoidCallback? onResendOtp;
  final VoidCallback? onVerify;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.onBackPressed,
    this.onChangeNumber,
    this.onResendOtp,
    this.onVerify,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpProvider _otpProvider = OtpProvider();

  @override
  void initState() {
    super.initState();
    // Start the timer with 54 seconds to exactly match the Figma design screenshot
    _otpProvider.initTimer(initialSeconds: 54);
  }

  @override
  void dispose() {
    _otpProvider.dispose();
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

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Back Button Layer
                      Positioned(
                        top: height * (24.0 / 852.0),
                        left: width * (24.0 / 393.0),
                        child: _buildBackButton(width),
                      ),
                      
                      // Main Content Layer
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * (24.0 / 393.0)),
                        child: Column(
                          children: [
                            SizedBox(height: height * (100.0 / 852.0)), // Offset for back button and header spacing
                            
                            // Title
                            Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: width * (24.0 / 393.0),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (16.0 / 852.0)),
                            
                            // Subtitle
                            Text(
                              'We sent a 6-digit code to +91 ${widget.phoneNumber}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * (14.0 / 393.0),
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (8.0 / 852.0)),
                            
                            // Change Number Link
                            GestureDetector(
                              onTap: widget.onChangeNumber,
                              child: Text(
                                'Change number',
                                style: TextStyle(
                                  fontSize: width * (14.0 / 393.0),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00A63E), // Primary green
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            
                            SizedBox(height: height * (40.0 / 852.0)),
                            
                            // OTP Input Boxes
                            ListenableBuilder(
                              listenable: _otpProvider,
                              builder: (context, _) {
                                return Column(
                                  children: [
                                    OtpInputWidget(
                                      hasError: _otpProvider.hasError,
                                      onChanged: (code) {
                                        _otpProvider.setOtpCode(code);
                                      },
                                    ),
                                    if (_otpProvider.hasError)
                                      Padding(
                                        padding: EdgeInsets.only(top: height * (12.0 / 852.0)),
                                        child: Text(
                                          'Invalid or expired OTP. Please try again.',
                                          style: TextStyle(
                                            fontSize: width * (13.0 / 393.0),
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }
                            ),
                            
                            SizedBox(height: height * (40.0 / 852.0)),
                            
                            // Resend Timer / Resend Button
                            ListenableBuilder(
                              listenable: _otpProvider,
                              builder: (context, _) {
                                return _otpProvider.canResend
                                    ? GestureDetector(
                                        onTap: () {
                                          _otpProvider.resendOtp(onResend: () {
                                            widget.onResendOtp?.call();
                                          });
                                        },
                                        child: Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            fontSize: width * (14.0 / 393.0),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF00A63E),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Resend OTP in 00:${_otpProvider.timerSeconds.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: width * (14.0 / 393.0),
                                          color: const Color(0xFF6B7280),
                                          fontFamily: 'Inter',
                                        ),
                                      );
                              },
                            ),
                            
                            SizedBox(height: height * (40.0 / 852.0)),
                            
                            // Verify & Continue Button
                            ListenableBuilder(
                              listenable: _otpProvider,
                              builder: (context, _) {
                                return Container(
                                  width: double.infinity,
                                  height: height * (52.0 / 852.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: _otpProvider.isValid 
                                      ? const LinearGradient(
                                          colors: [Color(0xFF00A63E), Color(0xFF008236)],
                                          stops: [0.3026, 1.0],
                                        )
                                      : null,
                                    color: !_otpProvider.isValid ? Colors.grey.shade300 : null,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: _otpProvider.isValid && !_otpProvider.isLoading
                                          ? () {
                                              _otpProvider.verifyOtp(onSuccess: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CompleteProfileScreen(
                                                      onBackPressed: () => Navigator.pop(context),
                                                    ),
                                                  ),
                                                );
                                                widget.onVerify?.call();
                                              });
                                            }
                                          : null,
                                      child: Center(
                                        child: _otpProvider.isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Verify & Continue',
                                                style: TextStyle(
                                                  color: _otpProvider.isValid ? Colors.white : Colors.grey.shade500,
                                                  fontSize: width * (16.0 / 393.0),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                            
                            SizedBox(height: height * (16.0 / 852.0)), // Gap between button and security text
                            
                            // Footer Security Message
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline, size: 16, color: Color(0xFF6B7280)),
                                SizedBox(width: width * (6.0 / 393.0)),
                                Text(
                                  'Your data is encrypted and secure',
                                  style: TextStyle(
                                    fontSize: width * (13.0 / 393.0),
                                    color: const Color(0xFF4B5563),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            
                            const Spacer(), // Push remaining space to bottom
                            SizedBox(height: height * (40.0 / 852.0)), // Bottom padding
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

  Widget _buildBackButton(double width) {
    return Container(
      width: width * (48.0 / 393.0),
      height: width * (48.0 / 393.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: widget.onBackPressed,
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF111827),
              size: width * (20.0 / 393.0),
            ),
          ),
        ),
      ),
    );
  }
}
