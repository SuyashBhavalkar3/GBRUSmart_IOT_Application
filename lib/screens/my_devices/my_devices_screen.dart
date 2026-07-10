import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home_dashboard/app_colors.dart';
import '../../home_dashboard/models/mobile_auto_device_model.dart';
import '../../home_dashboard/providers/mobile_auto_provider.dart';
import '../../home_dashboard/widgets/mobile_auto/device_card.dart';
import '../../home_dashboard/widgets/mobile_auto/add_device_empty_state.dart';
import '../../home_dashboard/widgets/mobile_auto/transfer_ownership_dialog.dart';
import '../../home_dashboard/screens/mobile_auto/select_device_to_activate_screen.dart';
import '../../home_dashboard/screens/home_dashboard_screen.dart';
import '../../home_dashboard/Knowledge_hub/knowledge_hub_screen.dart';
import '../../home_dashboard/My_Profile/profile_screen.dart';
import '../../control_device/screens/device_dashboard_screen.dart';

/// Screen 8: Bottom-nav level screen displaying the user's owned and linked devices.
class MyDevicesScreen extends ConsumerStatefulWidget {
  const MyDevicesScreen({super.key});

  @override
  ConsumerState<MyDevicesScreen> createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends ConsumerState<MyDevicesScreen> {
  int _activeTab = 0; // 0: My Approved Devices, 1: Add Devices
  final int _currentIndex = 0; // Current bottom nav index

  void _showTransferDialog(MobileAutoDevice device) {
    showDialog(
      context: context,
      builder: (context) => TransferOwnershipDialog(
        deviceName: device.deviceName,
        currentOwnerLabel: 'another owner',
        onConfirm: () {
          ref
              .read(mobileAutoProvider.notifier)
              .confirmTransferOwnership(device.imeiNumber);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ownership of ${device.deviceName} transferred successfully!',
              ),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(mobileAutoProvider);
    final approvedList = onboardingState.approvedDevices;
    final linkedList = onboardingState.linkedDevices;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match dashboard color
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeDashboardScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'My Devices',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top segmented pill toggle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSegmentedToggle(),
            ),

            // Tab Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_activeTab == 0)
                      _buildApprovedDevicesTab(approvedList)
                    else
                      _buildAddDevicesTab(),

                    const SizedBox(height: 24.0),

                    // Always-visible "My Linked Devices" section
                    const Text(
                      'My Linked Devices',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildLinkedDevicesGrid(linkedList),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSegmentedToggle() {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _activeTab == 0
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Center(
                  child: Text(
                    'My Approved Devices',
                    style: TextStyle(
                      color: _activeTab == 0
                          ? Colors.white
                          : AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _activeTab == 1
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Center(
                  child: Text(
                    'Add Devices',
                    style: TextStyle(
                      color: _activeTab == 1
                          ? Colors.white
                          : AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedDevicesTab(List<MobileAutoDevice> approvedList) {
    if (approvedList.isEmpty) {
      return AddDeviceEmptyState(
        title: 'No Approved Devices',
        subtitle:
            'You do not have any approved devices registered under your account.',
        buttonLabel: 'Register Device',
        onButtonPressed: () => setState(() => _activeTab = 1),
      );
    }

    // Sort devices: registeredToAnotherOwner first
    final sortedList = List<MobileAutoDevice>.from(approvedList);
    sortedList.sort((a, b) {
      if (a.ownershipStatus == DeviceOwnershipStatus.registeredToAnotherOwner &&
          b.ownershipStatus != DeviceOwnershipStatus.registeredToAnotherOwner) {
        return -1;
      }
      if (a.ownershipStatus != DeviceOwnershipStatus.registeredToAnotherOwner &&
          b.ownershipStatus == DeviceOwnershipStatus.registeredToAnotherOwner) {
        return 1;
      }
      return 0;
    });

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final device = sortedList[index];
        final isTransferNeeded =
            device.ownershipStatus ==
            DeviceOwnershipStatus.registeredToAnotherOwner;

        if (isTransferNeeded) {
          // Wrapped in a warning container with an orange top label
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE65100),
                      size: 14.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      'Registered to Another Owner',
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              DeviceCard(
                device: device,
                variant: DeviceCardVariant.transferNeeded,
                onPrimaryAction: () => _showTransferDialog(device),
              ),
            ],
          );
        }

        return DeviceCard(
          device: device,
          variant: DeviceCardVariant.approved,
          onCardTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DeviceDashboardScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddDevicesTab() {
    return AddDeviceEmptyState(
      title: 'No Devices Added Yet',
      subtitle:
          "We couldn't find any Mobile Auto devices linked to your account.",
      buttonLabel: 'Add Your Device',
      onButtonPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SelectDeviceToActivateScreen(),
          ),
        );
      },
    );
  }

  Widget _buildLinkedDevicesGrid(List<MobileAutoDevice> linkedList) {
    if (linkedList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No linked devices shared with you.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13.0),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: linkedList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.85, // Adjust size ratio for a compact linked cell
      ),
      itemBuilder: (context, index) {
        final device = linkedList[index];
        return DeviceCard(
          device: device,
          variant: DeviceCardVariant.linked,
          onCardTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DeviceDashboardScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 72.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.layers_outlined, 'My Devices'),
          _buildNavItem(1, Icons.widgets_outlined, 'Product'),
          _buildNavItem(2, Icons.home_outlined, 'Home'),
          _buildNavItem(3, Icons.book_outlined, 'Knowledge'),
          _buildNavItem(4, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 20.0),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (index == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeDashboardScreen(),
            ),
          );
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const KnowledgeHubScreen()),
          );
        } else if (index == 4) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textGrey, size: 22.0),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
