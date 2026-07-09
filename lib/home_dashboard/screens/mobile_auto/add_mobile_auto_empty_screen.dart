import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../widgets/mobile_auto/add_device_empty_state.dart';
import 'add_device_id_screen.dart';

/// Screen displayed when no Mobile Auto devices are linked to the user's account.
class AddMobileAutoEmptyScreen extends StatelessWidget {
  const AddMobileAutoEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AddDeviceEmptyState(
              title: 'No Devices Found',
              subtitle: "We couldn't find any Mobile Auto devices linked to your account.",
              buttonLabel: 'Add Using Device ID',
              onButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddDeviceIdScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
