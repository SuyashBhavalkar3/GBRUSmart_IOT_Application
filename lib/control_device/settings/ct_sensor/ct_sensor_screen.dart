import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ct_sensor_provider.dart';

class CtSensorScreen extends ConsumerWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSaveSettings;

  const CtSensorScreen({
    super.key,
    this.onBackPressed,
    this.onSaveSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctSensorProvider);
    final notifier = ref.read(ctSensorProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;
            final double width = constraints.maxWidth;
            final double scale = width / 393.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // --- App Bar ---
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(24 * scale, 24 * scale, 24 * scale, 16 * scale),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBackButton(scale),
                            SizedBox(width: 16 * scale),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CT Sensor',
                                    style: TextStyle(
                                      fontSize: 20 * scale,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF111827),
                                      fontFamily: 'Inter',
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 4 * scale),
                                  Text(
                                    'Select the current transformer connected to device',
                                    style: TextStyle(
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                      fontFamily: 'Inter',
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 8 * scale),

                      // --- CT Selection Cards ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                        child: Column(
                          children: [
                            _buildOptionCard(
                              rating: 30,
                              selectedCt: state.selectedCt,
                              icon: Icons.show_chart,
                              iconBgColor: const Color(0xFF2E7D32), // Dark green bg for icon in design
                              iconColor: Colors.white,
                              title: '30A CT',
                              description: 'Used for smaller motors with lower current load.',
                              scale: scale,
                              onTap: () => notifier.setCtRating(30),
                            ),
                            SizedBox(height: 12 * scale),
                            _buildOptionCard(
                              rating: 60,
                              selectedCt: state.selectedCt,
                              icon: Icons.speed,
                              iconBgColor: const Color(0xFFFFF2EB),
                              iconColor: const Color(0xFFEA580C),
                              title: '60A CT',
                              description: 'Suitable for medium-sized motors.',
                              scale: scale,
                              onTap: () => notifier.setCtRating(60),
                            ),
                            SizedBox(height: 12 * scale),
                            _buildOptionCard(
                              rating: 100,
                              selectedCt: state.selectedCt,
                              icon: Icons.bolt,
                              iconBgColor: const Color(0xFFFEE2E2),
                              iconColor: const Color(0xFFDC2626),
                              title: '100A CT',
                              description: 'Used for larger motors with higher current requirements.',
                              scale: scale,
                              onTap: () => notifier.setCtRating(100),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16 * scale),

                      // --- Current Selection Card ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1FDF6),
                            borderRadius: BorderRadius.circular(16 * scale),
                            border: Border.all(color: const Color(0xFFC6F6D5)),
                          ),
                          padding: EdgeInsets.all(20 * scale),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6 * scale),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E7D32),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16 * scale,
                                ),
                              ),
                              SizedBox(width: 12 * scale),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Selection',
                                      style: TextStyle(
                                        fontSize: 16 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF111827),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    RichText(
                                      text: TextSpan(
                                        text: 'You have selected: ',
                                        style: TextStyle(
                                          fontSize: 13 * scale,
                                          color: const Color(0xFF4B5563),
                                          fontFamily: 'Inter',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${state.selectedCt}A CT Sensor',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF00A63E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4 * scale),
                                    Text(
                                      'Device configuration will update\nafter saving.',
                                      style: TextStyle(
                                        fontSize: 12 * scale,
                                        color: const Color(0xFF6B7280),
                                        fontFamily: 'Inter',
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16 * scale),

                      // --- Technical Specifications Card ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.0392),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20 * scale),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: const Color(0xFF4B5563),
                                    size: 20 * scale,
                                  ),
                                  SizedBox(width: 8 * scale),
                                  Text(
                                    'Technical Specifications',
                                    style: TextStyle(
                                      fontSize: 15 * scale,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF111827),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16 * scale),
                              _buildSpecRow('30A CT', '0.5 - 30A range', scale),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6 * scale),
                                child: Divider(height: 1, color: const Color(0xFFF3F4F6)),
                              ),
                              _buildSpecRow('60A CT', '1 - 60A range', scale),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6 * scale),
                                child: Divider(height: 1, color: const Color(0xFFF3F4F6)),
                              ),
                              _buildSpecRow('100A CT', '2 - 100A range', scale),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32 * scale),
                      
                      // --- Bottom Section ---
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(24 * scale, 16 * scale, 24 * scale, 24 * scale),
                        child: Column(
                          children: [
                            // Save Settings Button
                            Container(
                              width: double.infinity,
                              height: 52 * scale,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00A63E), Color(0xFF008236)],
                                  stops: [0.3026, 1.0],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: state.isLoading
                                      ? null
                                      : () {
                                          void performSave() async {
                                            bool isCancelled = false;
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (dialogContext) => _SendingCommandDialog(
                                                onCancel: () {
                                                  isCancelled = true;
                                                  notifier.cancelSave();
                                                  Navigator.of(dialogContext).pop();
                                                },
                                              ),
                                            );
                                            final success = await notifier.saveSettings();
                                            if (!context.mounted) return;
                                            if (isCancelled) return;
                                            Navigator.of(context).pop(); // Close Sending dialog
                                            
                                            if (success) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (dialogContext) => _CommandSuccessDialog(
                                                  onOkPressed: () {
                                                    Navigator.of(dialogContext).pop();
                                                    if (onSaveSettings != null) {
                                                      onSaveSettings!();
                                                    }
                                                  },
                                                ),
                                              );
                                            } else {
                                              // Show failure dialog
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (dialogContext) => _CommandFailedDialog(
                                                  onTryAgain: () {
                                                    Navigator.of(dialogContext).pop();
                                                    performSave();
                                                  },
                                                  onCancel: () {
                                                    Navigator.of(dialogContext).pop();
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                          performSave();
                                        },
                                  child: Center(
                                    child: state.isLoading
                                        ? SizedBox(
                                            width: 24 * scale,
                                            height: 24 * scale,
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Save Settings',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 * scale,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16 * scale),
                            
                            // Helper Text
                            Text(
                              'Device configuration will be updated after saving.',
                              style: TextStyle(
                                fontSize: 12 * scale,
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(double scale) {
    return Container(
      width: 44 * scale,
      height: 44 * scale,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Light grey background like design
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onBackPressed,
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF4B5563), // Dark grey icon
              size: 20 * scale,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int rating,
    required int selectedCt,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required double scale,
    required VoidCallback onTap,
  }) {
    final bool isSelected = rating == selectedCt;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white, // In the design, background stays mostly white, just border changes, but let's use white for now and slightly green if selected if needed.
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(
          color: isSelected ? const Color(0xFF00A63E) : const Color(0xFFE5E7EB),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.0314),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16 * scale),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16 * scale),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44 * scale,
                  height: 44 * scale,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 22 * scale,
                    ),
                  ),
                ),
                SizedBox(width: 16 * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15 * scale,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13 * scale,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Inter',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12 * scale),
                Container(
                  width: 24 * scale,
                  height: 24 * scale,
                  margin: EdgeInsets.only(top: 8 * scale),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFD1D5DB),
                      width: isSelected ? 6.0 * scale : 1.5 * scale,
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String leftText, String rightText, double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(
            fontSize: 13 * scale,
            color: const Color(0xFF6B7280),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          rightText,
          style: TextStyle(
            fontSize: 13 * scale,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

// --- Dialogs ---


class _SendingCommandDialog extends ConsumerWidget {
  final VoidCallback onCancel;

  const _SendingCommandDialog({required this.onCancel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctSensorProvider);
    final scale = MediaQuery.of(context).size.width / 393.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0 * scale),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.0 * scale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.0 * scale),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E7FF), // Light blue background
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 28 * scale,
                height: 28 * scale,
                child: const CircularProgressIndicator(
                  color: Color(0xFF155DFC),
                  strokeWidth: 3.5,
                ),
              ),
            ),
            SizedBox(height: 24 * scale),
            Text(
              'Sending Command',
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 8 * scale),
            Text(
              '${state.selectedCt}A CT Sensor',
              style: TextStyle(
                fontSize: 14 * scale,
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 64 * scale), // Massive space before button
            SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
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

class _CommandFailedDialog extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onCancel;

  const _CommandFailedDialog({
    required this.onTryAgain,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0 * scale),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.0 * scale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.0 * scale),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7), // Light orange background
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFE17100),
                size: 28 * scale,
              ),
            ),
            SizedBox(height: 20 * scale),
            Text(
              'Command Failed',
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12 * scale),
            Text(
              'Could not send SMS command to\ndevice. Please check your network\nand try again.\n\nPlease check your network or\nSIM settings.',
              style: TextStyle(
                fontSize: 14 * scale,
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32 * scale),
            SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: onTryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A63E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            SizedBox(height: 12 * scale),
            SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    fontFamily: 'Inter',
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

class _CommandSuccessDialog extends StatelessWidget {
  final VoidCallback onOkPressed;

  const _CommandSuccessDialog({
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0 * scale),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.0 * scale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.0 * scale),
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5), // Very light green background
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: const Color(0xFF00A63E), // Primary green
                size: 28 * scale,
              ),
            ),
            SizedBox(height: 20 * scale),
            Text(
              'Command Sent\nSuccessfully',
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                fontFamily: 'Inter',
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12 * scale),
            Text(
              'Command has been sent to the device.\n\nYou will receive confirmation via\nSMS on your phone.',
              style: TextStyle(
                fontSize: 14 * scale,
                color: const Color(0xFF6B7280),
                fontFamily: 'Inter',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32 * scale),
            SizedBox(
              width: double.infinity,
              height: 52 * scale,
              child: ElevatedButton(
                onPressed: onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A63E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Inter',
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
