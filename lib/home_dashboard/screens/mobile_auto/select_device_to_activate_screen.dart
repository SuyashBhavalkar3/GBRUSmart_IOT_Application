import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/device_card.dart';
import 'add_device_id_screen.dart';
import 'confirm_otp_step1_screen.dart';

/// Screen displaying pre-registered devices awaiting activation.
class SelectDeviceToActivateScreen extends ConsumerWidget {
  const SelectDeviceToActivateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Two mock pre-registered devices
    final mockDevices = [
      MobileAutoDevice(
        deviceName: 'Mobile Auto',
        imeiNumber: '867530999123456',
        masterNumber: '+91 98765 43210',
        installedDate: DateTime(2026, 2, 12),
        ownershipStatus: DeviceOwnershipStatus.owned,
        isActive: false,
      ),
      MobileAutoDevice(
        deviceName: 'Mobile Auto',
        imeiNumber: '867530999999999', // Triggers registeredToAnotherOwner state
        masterNumber: '+91 90000 12345',
        installedDate: DateTime(2026, 2, 15),
        ownershipStatus: DeviceOwnershipStatus.registeredToAnotherOwner,
        isActive: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Mobile Auto',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My घर (Home) Devices',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Select a device to activate in Smart Gbru.',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.separated(
                  itemCount: mockDevices.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final device = mockDevices[index];
                    return DeviceCard(
                      device: device,
                      variant: DeviceCardVariant.activation,
                      onPrimaryAction: () {
                        // Pre-fill provider state and start resend OTP timer
                        ref.read(mobileAutoProvider.notifier).activateExistingDevice(device);
                        
                        // Navigate to confirm_otp_step1_screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ConfirmOtpStep1Screen(
                              buttonLabel: 'Verify & Add Device',
                              showSecurityNote: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Footnotes: Add using device ID or QR link
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddDeviceIdScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Add Using Device ID or QR',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Use this if your device is not listed',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12.0,
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
    );
  }
}
