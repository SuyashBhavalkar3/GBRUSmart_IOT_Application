import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import '../../widgets/mobile_auto/device_details_card.dart';
import 'add_device_id_screen.dart';
import 'select_device_to_activate_screen.dart';
import 'ownership_transfer_request_screen.dart';
import '../home_dashboard_screen.dart';

/// Screen 7: Success screen displayed when the device is added successfully.
/// Supports both self-owned devices and devices owned by another user.
class DeviceAddedSuccessScreen extends ConsumerWidget {
  final DeviceOwnershipStatus? ownershipStatus;

  const DeviceAddedSuccessScreen({
    super.key,
    this.ownershipStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(mobileAutoProvider);
    final notifier = ref.read(mobileAutoProvider.notifier);

    // Determine the active ownership status (prefer parameter, fallback to provider state)
    final activeStatus = ownershipStatus ??
        onboardingState.ownershipStatus ??
        DeviceOwnershipStatus.owned;

    final isSelfOwned = activeStatus == DeviceOwnershipStatus.owned;

    // Default IMEI if empty
    final imei = onboardingState.deviceId?.isNotEmpty == true
        ? onboardingState.deviceId!
        : '867530999123456';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Badge: Green rounded-square with a white check & bolt
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withAlpha(76),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          color: AppColors.primaryGreen,
                          size: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              
              // Bold heading
              const Text(
                'Device Added Successfully',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              
              // Subtext: Conditional based on ownership
              Text(
                isSelfOwned
                    ? 'Your Mobile Auto device is now connected. You can start controlling and monitoring your motor from the app.'
                    : "The device has been verified, but it's currently registered to another owner. Please transfer ownership to continue.",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textGrey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              
              // Device Details Card
              DeviceDetailsCard(
                device: MobileAutoDevice(
                  deviceName: 'Mobile Auto',
                  imeiNumber: imei,
                  masterNumber: onboardingState.contactNumber ?? '+91 98765 43210',
                  installedDate: DateTime.now(),
                  ownershipStatus: activeStatus,
                  isActive: true,
                ),
              ),
              const SizedBox(height: 20.0),
              
              // Info/Warning Banner: Conditional based on ownership
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isSelfOwned ? AppColors.lightGreenBg : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isSelfOwned
                        ? AppColors.primaryGreen.withAlpha(51)
                        : const Color(0xFFFFB74D).withAlpha(51),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelfOwned ? Icons.verified_user : Icons.warning_amber_rounded,
                      color: isSelfOwned ? AppColors.primaryGreen : const Color(0xFFE65100),
                      size: 20.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        isSelfOwned
                            ? 'You are the registered owner of this device.'
                            : 'This device is registered to another owner.',
                        style: TextStyle(
                          color: isSelfOwned ? AppColors.primaryGreen : const Color(0xFFE65100),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Action Buttons: If not self-owned, show "Transfer Ownership" button above
              if (!isSelfOwned) ...[
                PrimaryGradientButton(
                  label: 'Transfer Ownership',
                  backgroundColor: const Color(0xFFE65100),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OwnershipTransferRequestScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
              ],
              
              // Go to Device Dashboard button
              PrimaryGradientButton(
                label: 'Go to Device Dashboard',
                onPressed: () {
                  // Add device to live approvedDevices list in provider
                  ref.read(mobileAutoProvider.notifier).addApprovedDevice(
                    MobileAutoDevice(
                      deviceName: 'Mobile Auto',
                      imeiNumber: imei,
                      masterNumber: onboardingState.contactNumber ?? '+91 98765 43210',
                      installedDate: DateTime.now(),
                      ownershipStatus: activeStatus,
                      isActive: true,
                    ),
                  );
                  // Navigate to Home and clear the entire stack
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeDashboardScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 16.0),
              
              // Add Another Device link: conditional back routing
              GestureDetector(
                onTap: () {
                  final wasActivationFlow = onboardingState.ownershipStatus != null;
                  notifier.resetFlow();
                  
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => wasActivationFlow
                          ? const SelectDeviceToActivateScreen()
                          : const AddDeviceIdScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Add Another Device',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
