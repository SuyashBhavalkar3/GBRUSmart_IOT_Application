import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../models/mobile_auto_device_model.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import 'confirm_otp_step1_screen.dart';

/// Screen to request device ownership transfer when the previous owner is unavailable.
class OwnershipTransferRequestScreen extends ConsumerStatefulWidget {
  const OwnershipTransferRequestScreen({super.key});

  @override
  ConsumerState<OwnershipTransferRequestScreen> createState() => _OwnershipTransferRequestScreenState();
}

class _OwnershipTransferRequestScreenState extends ConsumerState<OwnershipTransferRequestScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedReason;
  bool _isReasonDropdownOpen = false;
  
  bool _isUploading = false;
  String? _uploadedFileName;

  final List<String> _transferReasons = [
    'Device purchased from another farmer',
    'Previous owner unavailable',
    'Wrong number registered during installation',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _toggleReasonDropdown() {
    setState(() {
      _isReasonDropdownOpen = !_isReasonDropdownOpen;
    });
  }

  void _selectReason(String reason) {
    setState(() {
      _selectedReason = reason;
      _isReasonDropdownOpen = false;
    });
  }

  Future<void> _simulateUpload() async {
    setState(() {
      _isUploading = true;
    });
    // Fake upload network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isUploading = false;
      _uploadedFileName = 'receipt_invoice.png';
    });
  }

  void _removeUploadedFile() {
    setState(() {
      _uploadedFileName = null;
    });
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _selectedReason != null;
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(mobileAutoProvider);
    
    // Retrieve dynamic IMEI and Master Number from provider state
    final imei = onboardingState.deviceId?.isNotEmpty == true
        ? onboardingState.deviceId!
        : '867530999123456';
    final masterNo = onboardingState.contactNumber?.isNotEmpty == true
        ? onboardingState.contactNumber!
        : '+91 98765 43210';
        
    // Create a dummy device to access the maskedImei formatting helper
    final dummyDevice = MobileAutoDevice(
      deviceName: 'Mobile Auto',
      imeiNumber: imei,
      masterNumber: masterNo,
      installedDate: DateTime(2026, 2, 12),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match light green layout background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ownership Transfer Request',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Submit a request if the current device owner is unavailable to approve transfer.',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Device Details Header
                    const Text(
                      'Device Details',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Card visual matching screenshot
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEBF7F0),
                            ),
                            child: const Center(
                              child: Text(
                                'D',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mobile Auto',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'IMEI No. ${dummyDevice.maskedImei}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppColors.warningOrange,
                                      size: 12.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Master: ${dummyDevice.masterNumber}',
                                      style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                const Text(
                                  'Installed: 12 Feb 2026',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Your Details Section
                    const Text(
                      'Your Details',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    _buildLabel('Full Name'),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Enter your full name',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16.0),

                    _buildLabel('Mobile Number'),
                    _buildDisabledField('+91 9000001221'),
                    const SizedBox(height: 16.0),

                    _buildLabel('Village / Location'),
                    _buildTextField(
                      controller: _locationController,
                      hintText: 'Enter your village or location',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24.0),

                    // Reason section
                    const Text(
                      'Reason for Ownership Transfer',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Dropdown trigger card
                    GestureDetector(
                      onTap: _toggleReasonDropdown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: _isReasonDropdownOpen ? AppColors.primaryGreen : AppColors.borderGrey,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedReason ?? 'Select a reason',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: _selectedReason != null ? AppColors.textDark : AppColors.textGrey,
                                fontWeight: _selectedReason != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            Icon(
                              _isReasonDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: AppColors.textGrey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded accordion layout matching screenshot
                    if (_isReasonDropdownOpen) ...[
                      const SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: Column(
                          children: _transferReasons.map((reason) {
                            final isSelected = _selectedReason == reason;
                            return GestureDetector(
                              onTap: () => _selectReason(reason),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFEBF7F0) : Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: reason == _transferReasons.last ? Colors.transparent : AppColors.borderGrey,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  reason,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: AppColors.textDark,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24.0),

                    // Upload Proof Section
                    const Text(
                      'Upload Proof (Optional but Recommended)',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Upload purchase invoice or photo of device label.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    _buildUploadProofContainer(),

                    const SizedBox(height: 24.0),

                    // Additional Notes
                    const Text(
                      'Additional Notes (Optional)',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    _buildTextField(
                      controller: _notesController,
                      hintText: 'Add additional information (optional)',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),

            // Bottom Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: PrimaryGradientButton(
                label: 'Submit Request',
                isEnabled: _isFormValid(),
                onPressed: () {
                  // Start OTP timer for step 1 verification
                  ref.read(mobileAutoProvider.notifier).startResendTimer();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConfirmOtpStep1Screen(
                        buttonLabel: 'Verify & Continue',
                        showSecurityNote: true,
                        isTransferFlow: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.0,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.0, color: AppColors.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _buildDisabledField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey disabled background color
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14.0,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUploadProofContainer() {
    if (_uploadedFileName != null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, color: AppColors.primaryGreen, size: 28.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _uploadedFileName!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Text(
                    'Uploaded successfully',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
              onPressed: _removeUploadedFile,
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _isUploading ? null : _simulateUpload,
      child: CustomPaint(
        painter: DashedBorderPainter(color: AppColors.borderGrey, radius: 12.0),
        child: Container(
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: _isUploading
                ? const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_upload_outlined, color: AppColors.textGrey, size: 24.0),
                      SizedBox(height: 6.0),
                      Text(
                        'Tap to upload image',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Supporting: JPG / PNG',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw clean dashed borders without requiring external dependencies.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    // Compute dashed path
    final dashPath = Path();
    double distance = 0.0;
    
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
