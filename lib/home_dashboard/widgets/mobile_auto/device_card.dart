import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';
import 'primary_gradient_button.dart';

/// Enum representing the visual and functional variants of the DeviceCard.
enum DeviceCardVariant { activation, approved, transferNeeded, linked }

/// A unified device card component used in lists and grids across the app.
class DeviceCard extends StatelessWidget {
  final MobileAutoDevice device;
  final DeviceCardVariant variant;
  final VoidCallback?
  onPrimaryAction; // Taps on "Activate" or "Transfer Ownership"
  final VoidCallback? onCardTap; // Tap handler for approved cards

  const DeviceCard({
    super.key,
    required this.device,
    required this.variant,
    this.onPrimaryAction,
    this.onCardTap,
  });

  /// Helper to convert a month index to shorthand name.
  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isLinked = variant == DeviceCardVariant.linked;
    final padding = isLinked
        ? const EdgeInsets.all(10.0)
        : const EdgeInsets.all(16.0);

    // Main card wrapper
    Widget cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title, badge, and optional edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isLinked ? 6.0 : 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreenBg,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.phone_android,
                        color: AppColors.primaryGreen,
                        size: isLinked ? 14.0 : 18.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        device.deviceName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isLinked ? 12.0 : 15.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4.0),
              // Conditional Badge/Icon based on variant
              _buildTopRightDecoration(),
            ],
          ),
          const SizedBox(height: 12.0),

          // IMEI Number
          Text(
            'IMEI NO.',
            style: TextStyle(
              fontSize: isLinked ? 9.0 : 11.0,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            device.maskedImei,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isLinked ? 11.0 : 14.0,
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),

          // Master number details
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warningOrange,
                      size: isLinked ? 10.0 : 12.0,
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      'Master',
                      style: TextStyle(
                        color: const Color(0xFFE65100),
                        fontSize: isLinked ? 8.0 : 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: Text(
                  device.masterNumber,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isLinked ? 11.0 : 13.0,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Installation date
          Text(
            'Installed: ${_formatDate(device.installedDate)}',
            style: TextStyle(
              fontSize: isLinked ? 10.0 : 12.0,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Bottom button visual overrides
          if (variant == DeviceCardVariant.activation ||
              variant == DeviceCardVariant.transferNeeded) ...[
            const Divider(height: 20.0, color: AppColors.borderGrey),
            PrimaryGradientButton(
              label: variant == DeviceCardVariant.activation
                  ? 'Activate'
                  : 'Transfer Ownership',
              backgroundColor: variant == DeviceCardVariant.activation
                  ? null
                  : const Color(0xFFE65100),
              onPressed: onPrimaryAction,
            ),
          ],
        ],
      ),
    );

    // If approved or linked, make the whole card tappable
    if ((variant == DeviceCardVariant.approved ||
            variant == DeviceCardVariant.linked) &&
        onCardTap != null) {
      return GestureDetector(onTap: onCardTap, child: cardContent);
    }

    return cardContent;
  }

  Widget _buildTopRightDecoration() {
    switch (variant) {
      case DeviceCardVariant.activation:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: const Color(0xFFFFB74D), width: 0.5),
          ),
          child: const Text(
            'Not Activated',
            style: TextStyle(
              color: Color(0xFFE65100),
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DeviceCardVariant.approved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGreenBg,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColors.primaryGreen.withAlpha(51),
                  width: 0.5,
                ),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(
              Icons.edit_outlined,
              color: AppColors.textGrey,
              size: 18.0,
            ),
          ],
        );
      case DeviceCardVariant.transferNeeded:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: const Color(0xFFFFB74D), width: 0.5),
          ),
          child: const Text(
            'Not Active',
            style: TextStyle(
              color: Color(0xFFE65100),
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case DeviceCardVariant.linked:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.lightGreenBg,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Text(
            'Active',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 8.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
