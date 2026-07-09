import 'package:flutter/material.dart';
import '../../app_colors.dart';
import 'primary_gradient_button.dart';

/// A modal dialog used to verify and confirm transferring a device's ownership.
class TransferOwnershipDialog extends StatefulWidget {
  final String deviceName;
  final String currentOwnerLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const TransferOwnershipDialog({
    super.key,
    required this.deviceName,
    required this.currentOwnerLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<TransferOwnershipDialog> createState() => _TransferOwnershipDialogState();
}

class _TransferOwnershipDialogState extends State<TransferOwnershipDialog> {
  bool _isCheckboxTicked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const Text(
              'Transfer Device Ownership?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16.0),
            
            // Body text with interpolated owner label
            Text(
              'This device is currently registered to ${widget.currentOwnerLabel}. The previous owner will be removed and you will become the new primary owner.',
              style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.textGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            
            // Checkbox Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: Checkbox(
                    activeColor: AppColors.primaryGreen,
                    value: _isCheckboxTicked,
                    onChanged: (val) {
                      setState(() {
                        _isCheckboxTicked = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: Text(
                    "I've confirmed the device's IMEI and MAC ID are correct.",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28.0),
            
            // Confirm Transfer Button
            PrimaryGradientButton(
              label: 'Confirm Transfer',
              isEnabled: _isCheckboxTicked,
              onPressed: widget.onConfirm,
            ),
            const SizedBox(height: 16.0),
            
            // Cancel Link
            Center(
              child: GestureDetector(
                onTap: widget.onCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
