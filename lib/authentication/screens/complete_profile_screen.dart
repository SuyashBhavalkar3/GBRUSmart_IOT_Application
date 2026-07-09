import 'package:flutter/material.dart';
import '../providers/complete_profile_provider.dart';
import 'location_details_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSaveAndContinue;

  const CompleteProfileScreen({
    super.key,
    this.onBackPressed,
    this.onSaveAndContinue,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final CompleteProfileProvider _profileProvider = CompleteProfileProvider();
  
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _profileProvider.name);
    _emailController = TextEditingController(text: _profileProvider.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _profileProvider.dispose();
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
                      // Main Content Layer
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * (24.0 / 393.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * (100.0 / 852.0)), // Offset for back button
                            
                            // Title
                            Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                fontSize: width * (24.0 / 393.0),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (8.0 / 852.0)),
                            
                            // Subtitle
                            Text(
                              'Add your details .',
                              style: TextStyle(
                                fontSize: width * (14.0 / 393.0),
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Inter',
                              ),
                            ),
                            
                            SizedBox(height: height * (40.0 / 852.0)),
                            
                            // Form Fields
                            ListenableBuilder(
                              listenable: _profileProvider,
                              builder: (context, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTextField(
                                      label: 'Enter your Full Name',
                                      hintText: 'Jane Doe',
                                      controller: _nameController,
                                      onChanged: _profileProvider.setName,
                                      errorText: _profileProvider.nameError,
                                      keyboardType: TextInputType.name,
                                      width: width,
                                      height: height,
                                    ),
                                    
                                    SizedBox(height: height * (20.0 / 852.0)),
                                    
                                    _buildTextField(
                                      label: 'Enter your Email Address',
                                      hintText: 'jane.doe@gmail.com',
                                      controller: _emailController,
                                      onChanged: _profileProvider.setEmail,
                                      errorText: _profileProvider.emailError,
                                      keyboardType: TextInputType.emailAddress,
                                      width: width,
                                      height: height,
                                    ),
                                  ],
                                );
                              },
                            ),
                            
                            const Spacer(),
                            
                            // Save & Continue Button
                            ListenableBuilder(
                              listenable: _profileProvider,
                              builder: (context, _) {
                                return Container(
                                  width: double.infinity,
                                  height: height * (52.0 / 852.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: _profileProvider.isValid 
                                      ? const LinearGradient(
                                          colors: [Color(0xFF00A63E), Color(0xFF008236)],
                                          stops: [0.3026, 1.0],
                                        )
                                      : null,
                                    color: !_profileProvider.isValid ? Colors.grey.shade300 : null,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: _profileProvider.isValid && !_profileProvider.isLoading
                                          ? () {
                                              _profileProvider.saveAndContinue(onSuccess: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => LocationDetailsScreen(
                                                      onBackPressed: () => Navigator.pop(context),
                                                    ),
                                                  ),
                                                );
                                                widget.onSaveAndContinue?.call();
                                              });
                                            }
                                          : null,
                                      child: Center(
                                        child: _profileProvider.isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Save & Continue',
                                                style: TextStyle(
                                                  color: _profileProvider.isValid ? Colors.white : Colors.grey.shade500,
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
                            
                            SizedBox(height: height * (40.0 / 852.0)), // Bottom padding
                          ],
                        ),
                      ),
                      
                      // Back Button Layer
                      Positioned(
                        top: height * (24.0 / 852.0),
                        left: width * (24.0 / 393.0),
                        child: _buildBackButton(width),
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required Function(String) onChanged,
    required String? errorText,
    required TextInputType keyboardType,
    required double width,
    required double height,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: width * (12.0 / 393.0),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B5563),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: height * (8.0 / 852.0)),
        Container(
          height: height * (56.0 / 852.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: width * (16.0 / 393.0)),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: width * (16.0 / 393.0),
              color: const Color(0xFF1F2937),
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: width * (16.0 / 393.0),
                color: const Color(0xFF9CA3AF), // Grey placeholder
                fontFamily: 'Inter',
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: height * (8.0 / 852.0)),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: width * (12.0 / 393.0),
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
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
