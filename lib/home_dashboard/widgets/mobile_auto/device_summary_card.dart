import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';

/// Card component showing a summary of the device details, using live MobileAutoDevice data.
class DeviceSummaryCard extends StatelessWidget {
  final MobileAutoDevice device;

  const DeviceSummaryCard({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenBg,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.phone_android,
                  color: AppColors.primaryGreen,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                device.deviceName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'IMEI NO.',
            style: TextStyle(
              fontSize: 12.0,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            device.maskedImei,
            style: const TextStyle(
              fontSize: 15.0,
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 24.0, color: AppColors.borderGrey),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warningOrange,
                      size: 14.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Master',
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                device.masterNumber,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
