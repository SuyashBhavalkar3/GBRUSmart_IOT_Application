import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/login_provider.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginProvider _loginProvider = LoginProvider();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Marathi'];

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      _loginProvider.setPhoneNumber(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _loginProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF6), // Very light green background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final double width = constraints.maxWidth;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: height,
                      minWidth: width,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Give enough top space for the logo so it doesn't overlap the floating dropdown
                          SizedBox(height: height * (210.0 / 852.0)), 

                          // Logo Section
                          _buildLogoSection(width, height),

                          SizedBox(height: height * (18.0 / 852.0)), // Exact gap to subtitle

                          // Subtitle
                          Text(
                            'Login to manage your smart farm',
                            style: TextStyle(
                              fontSize: width * (15.0 / 393.0),
                              color: const Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),

                          SizedBox(height: height * (32.0 / 852.0)), // Exact gap to card

                          // Login Card
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * (24.0 / 393.0)),
                            child: _buildLoginCard(width, height),
                          ),

                          const Spacer(),

                          // Footer
                          _buildFooter(width, height),
                          
                          SizedBox(height: height * (40.0 / 852.0)), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Language Selector floating in Top Right Corner
                Positioned(
                  top: height * (24.0 / 852.0),
                  right: width * (24.0 / 393.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * (12.0 / 393.0), 
                      vertical: height * (6.0 / 852.0)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Inter',
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                          }
                        },
                        items: _languages.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.translate, size: 16, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * (25.9 / 852.0)),
              child: Text(
                'Smart',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: width * (44.0 / 393.0),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E4123),
                  height: 1.0,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            SizedBox(width: width * (5.0 / 393.0)),
            Image.asset(
              'assets/authentication_assets/download.png',
              height: height * (86.416 / 852.0),
              fit: BoxFit.contain,
            ),
          ],
        ),
        Transform.translate(
          offset: Offset(width * (30.55 / 393.0), height * (-8.816 / 852.0)),
          child: Text(
            'STRONG | SMART | SUPERIOR',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: width * (10.0 / 393.0), // Decreased from 14.0
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: const Color(0xFF1E4123),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(double width, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * (24.0 / 393.0),
        vertical: height * (24.0 / 852.0),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.0392),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your mobile number',
            style: TextStyle(
              fontSize: width * (16.0 / 393.0),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937), // Dark grey
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: height * (16.0 / 852.0)),
          
          // Phone Input Field
          Container(
            height: height * (56.0 / 852.0), // Exact height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * (16.0 / 393.0)),
                  child: Text(
                    '+91',
                    style: TextStyle(
                      fontSize: width * (16.0 / 393.0),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: height * (24.0 / 852.0),
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: width * (12.0 / 393.0)),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                      fontSize: width * (16.0 / 393.0),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      hintStyle: TextStyle(
                        fontSize: width * (16.0 / 393.0),
                        color: const Color(0xFF9CA3AF),
                        fontFamily: 'Inter',
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          ListenableBuilder(
            listenable: _loginProvider,
            builder: (context, _) {
              final showValidationError = _phoneController.text.isNotEmpty && 
                                          !_loginProvider.isValid && 
                                          _phoneController.text.length == 10;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showValidationError)
                    Padding(
                      padding: EdgeInsets.only(top: height * (8.0 / 852.0)),
                      child: Text(
                        'Please enter a valid 10-digit number.',
                        style: TextStyle(color: Colors.red.shade700, fontSize: width * (12.0 / 393.0)),
                      ),
                    ),
                  SizedBox(height: height * (32.0 / 852.0)), // Exact gap to button
                  
                  // Get OTP Button
                  Container(
                    width: double.infinity,
                    height: height * (52.0 / 852.0), // Exact button height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: _loginProvider.isValid 
                        ? const LinearGradient(
                            colors: [Color(0xFF00A63E), Color(0xFF008236)],
                            stops: [0.3026, 1.0],
                          )
                        : null,
                      color: !_loginProvider.isValid ? Colors.grey.shade300 : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: _loginProvider.isValid && !_loginProvider.isLoading
                            ? () {
                                _loginProvider.onGetOtp(onSuccess: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpVerificationScreen(
                                        phoneNumber: _loginProvider.phoneNumber,
                                        onBackPressed: () => Navigator.pop(context),
                                        onChangeNumber: () => Navigator.pop(context),
                                      ),
                                    ),
                                  );
                                });
                              }
                            : null,
                        child: Center(
                          child: _loginProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Get OTP',
                                  style: TextStyle(
                                    color: _loginProvider.isValid ? Colors.white : Colors.grey.shade500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(double width, double height) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Color(0xFF6B7280)), // Lock icon
            SizedBox(width: width * (6.0 / 393.0)),
            Text(
              'Secured with OTP verification',
              style: TextStyle(
                fontSize: width * (13.0 / 393.0),
                color: const Color(0xFF4B5563), // Medium grey
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        SizedBox(height: height * (6.0 / 852.0)),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'By continuing, you agree to our ',
              style: TextStyle(
                fontSize: width * (12.0 / 393.0),
                color: const Color(0xFF6B7280), // Light grey
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Expose Terms callback
              },
              child: Text(
                'Terms',
                style: TextStyle(
                  fontSize: width * (12.0 / 393.0),
                  color: const Color(0xFF3B82F6), // Blue link
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Text(
              ' & ',
              style: TextStyle(
                fontSize: width * (12.0 / 393.0),
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Expose Privacy Policy callback
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: width * (12.0 / 393.0),
                  color: const Color(0xFF3B82F6), // Blue link
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
