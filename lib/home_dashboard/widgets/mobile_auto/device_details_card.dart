import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';

/// Card component showing final device configuration details on the success screen.
class DeviceDetailsCard extends StatelessWidget {
  final MobileAutoDevice device;

  const DeviceDetailsCard({
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
          const Text(
            'Device Details',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildRow('Device Name', device.deviceName),
          const Divider(height: 20.0, color: AppColors.borderGrey),
          _buildRow('IMEI Number', device.maskedImei),
          const Divider(height: 20.0, color: AppColors.borderGrey),
          _buildRow(
            'Status',
            device.status,
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: device.isActive ? AppColors.primaryGreen : AppColors.warningOrange,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  device.status,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: device.isActive ? AppColors.primaryGreen : AppColors.warningOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Widget? trailingWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.textGrey,
          ),
        ),
        trailingWidget ??
            Text(
              value,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
      ],
    );
  }
}
