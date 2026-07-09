import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import '../widgets/mobile_auto/primary_gradient_button.dart';
import '../providers/mobile_auto_provider.dart';
import 'profile_provider.dart';

/// Screen 17: Raise Complaint page where users submit issues with custom reasons, priorities, and devices.
class RaiseComplaintScreen extends ConsumerStatefulWidget {
  const RaiseComplaintScreen({super.key});

  @override
  ConsumerState<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends ConsumerState<RaiseComplaintScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  String? _selectedRelatedDeviceImei;

  bool _isAttachingFile = false;
  String? _attachedFileName;

  final List<String> _categories = [
    'Device Issue',
    'Billing',
    'Account',
    'Other',
  ];

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
        _selectedCategory != null &&
        _descriptionController.text.trim().isNotEmpty;
  }

  Future<void> _simulateAttachment() async {
    setState(() {
      _isAttachingFile = true;
    });
    // Fake upload wait
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isAttachingFile = false;
      _attachedFileName = 'screenshot_device_error.png';
    });
  }

  void _removeAttachment() {
    setState(() {
      _attachedFileName = null;
    });
  }

  void _submitComplaint() {
    // Generate random ticket suffix
    final rng = Random();
    final ticketNum = 'MM-TKT-${rng.nextInt(9000) + 1000}';

    final newComplaint = ComplaintModel(
      id: ticketNum,
      ticketNumber: ticketNum,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      priority: _selectedPriority,
      relatedDeviceImei: _selectedRelatedDeviceImei,
      status: 'In Progress',
      submittedDate: DateTime.now(),
      timeline: [
        ComplaintTimelineEntry(
          label: 'Complaint Registered',
          timestamp: DateTime.now(),
        ),
      ],
    );

    ref.read(profileProvider.notifier).addComplaint(newComplaint);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complaint $ticketNum submitted successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final onboardingState = ref.watch(mobileAutoProvider);
    final devices = onboardingState.approvedDevices;



    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Raise Complaint',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
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
                      'Fill in the details below',
                      style: TextStyle(fontSize: 13.0, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 20.0),

                    // Complaint Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Complaint Title *'),
                        Text(
                          '${_titleController.text.length}/100',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: _titleController,
                      hint: 'Enter complaint title (e.g. Device connectivity issue)',
                      maxLength: 100,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16.0),

                    // Category Dropdown
                    _buildLabel('Category *'),
                    _buildDropdown<String>(
                      value: _selectedCategory,
                      hint: 'Select category',
                      items: _categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c,
                          child: Text(c, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Priority Dropdown
                    _buildLabel('Priority *'),
                    _buildDropdown<String>(
                      value: _selectedPriority,
                      hint: 'Select Priority',
                      items: _priorities.map((p) {
                        Color col = AppColors.primaryGreen;
                        if (p == 'High') col = AppColors.errorRed;
                        if (p == 'Medium') col = const Color(0xFFE65100);

                        return DropdownMenuItem<String>(
                          value: p,
                          child: Text(
                            p,
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: col),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedPriority = val ?? 'Medium';
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Related Device Dropdown
                    _buildLabel('Related Device (Optional)'),
                    _buildDropdown<String>(
                      value: _selectedRelatedDeviceImei,
                      hint: 'No specific device',
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('No specific device', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
                        ),
                        ...devices.map((d) {
                          return DropdownMenuItem<String>(
                            value: d.imeiNumber,
                            child: Text(
                              '${d.deviceName} (${d.maskedImei})',
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                            ),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedRelatedDeviceImei = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Description text area
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Description *'),
                        Text(
                          '${_descriptionController.text.length}/500',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: 'Please describe your complaint in detail...',
                      maxLines: 4,
                      maxLength: 500,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16.0),

                    // Contact Number (pref-filled, read-only)
                    _buildLabel('Contact Number'),
                    _buildDisabledField(profileState.phoneNumber),
                    const SizedBox(height: 20.0),

                    // Attachments Section
                    _buildLabel('Attachments (Optional)'),
                    const SizedBox(height: 6.0),
                    _buildAttachmentContainer(),
                    const SizedBox(height: 24.0),

                    // Info banner
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9).withAlpha(128),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.primaryGreen.withAlpha(51)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 18.0),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Our support team will review your complaint and respond within 24-48 hours. You will receive updates via SMS and app notifications.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),

            // Submit Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    label: 'Submit Complaint',
                    isEnabled: _isFormValid(),
                    onPressed: _submitComplaint,
                  ),
                  const SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
    required String hint,
    int maxLines = 1,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      style: const TextStyle(fontSize: 14.0, color: AppColors.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
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
        color: const Color(0xFFF5F5F5),
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

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.textGrey, fontSize: 14.0, fontWeight: FontWeight.normal)),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
        ),
      ),
    );
  }

  Widget _buildAttachmentContainer() {
    if (_attachedFileName != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            const Icon(Icons.image_outlined, color: AppColors.primaryGreen, size: 24.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                _attachedFileName!,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed, size: 22.0),
              onPressed: _removeAttachment,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        ),
        onPressed: _isAttachingFile ? null : _simulateAttachment,
        child: _isAttachingFile
          ? const SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_photo_alternate_outlined, color: AppColors.primaryGreen, size: 20.0),
                SizedBox(width: 8.0),
                Text(
                  'Upload Photo or Screenshot',
                  style: TextStyle(color: AppColors.primaryGreen, fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
      ),
    );
  }
}
