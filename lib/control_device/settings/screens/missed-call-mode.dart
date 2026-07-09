// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home_dashboard/widgets/mobile_auto/primary_gradient_button.dart';

// Styling Palette matching the device Settings screen
const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);

// TODO: flip this to true to preview the Command Failed dialog during development.
const bool _debugSimulateCommandFailure = false;

/// 4. In-Memory State Provider for Missed Call Mode
final missedCallModeProvider = StateProvider<bool>((ref) => false);

/// 2. Main Screen - Missed Call Mode
class MissedCallModeScreen extends ConsumerWidget {
  const MissedCallModeScreen({super.key});

  // Simulated command sending
  Future<bool> _sendDeviceCommand({required String action}) async {
    await Future.delayed(const Duration(seconds: 4));
    return !_debugSimulateCommandFailure;
  }

  // Toggle Command Flow
  void _triggerToggleFlow(BuildContext context, WidgetRef ref, bool targetValue) async {
    bool commandCancelled = false;
    final actionText = targetValue ? "Enable Missed call control" : "Disable Missed call control";
    final contextLabel = targetValue ? "Missed Call Mode Enabled" : "Missed Call Mode Disabled";

    // Show sending dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SendingCommandDialog(
        actionText: actionText,
        onCancel: () {
          commandCancelled = true;
          Navigator.of(context).pop();
        },
      ),
    );

    final success = await _sendDeviceCommand(action: actionText);
    if (commandCancelled) return;
    if (!context.mounted) return;

    // Close sending dialog
    Navigator.of(context).pop();

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandSuccessDialog(
          contextLabel: contextLabel,
          title: 'Command Sent Successfully',
          body: 'command has been sent to the device.\nYou will receive confirmation via SMS on your phone.',
          onOk: () {
            ref.read(missedCallModeProvider.notifier).state = targetValue;
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _CommandFailedDialog(
          onTryAgain: () {
            Navigator.of(context).pop();
            _triggerToggleFlow(context, ref, targetValue);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(missedCallModeProvider);

    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: textDark, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Missed call Mode',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Control motor using missed call',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Card 1 — Enable toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderGrey),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F7ED),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_callback_outlined,
                      color: primaryGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enable Missed Call Control',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Authorized numbers can start or stop the motor by giving a missed call.',
                          style: TextStyle(
                            fontSize: 12,
                            color: textGrey,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isEnabled,
                    // ignore: deprecated_member_use
                    activeColor: primaryGreen,
                    onChanged: (newValue) {
                      _triggerToggleFlow(context, ref, newValue);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card 2 — Device SIM Number
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF3FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF2F66F6),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Device SIM Number',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '+91 90123 45678',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.copy_outlined, color: textGrey, size: 18),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: '+91 90123 45678')).then((_) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Number copied'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Give a missed call to this number to control the motor.',
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // How It Works Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How It Works',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineStep(
                    stepNumber: '1',
                    badgeBgColor: const Color(0xFFEEF3FF),
                    badgeTextColor: const Color(0xFF2F66F6),
                    icon: Icons.phone_callback_outlined,
                    iconColor: const Color(0xFF2F66F6),
                    title: 'Give a Missed Call',
                    description: 'Give a missed call to the device SIM number.',
                  ),
                  _buildTimelineStep(
                    stepNumber: '2',
                    badgeBgColor: const Color(0xFFE6F7ED),
                    badgeTextColor: primaryGreen,
                    icon: Icons.bolt,
                    iconColor: primaryGreen,
                    title: 'Motor Starts',
                    description: 'Motor will start automatically.',
                  ),
                  _buildTimelineStep(
                    stepNumber: '3',
                    badgeBgColor: const Color(0xFFFEE2E2),
                    badgeTextColor: Colors.red,
                    icon: Icons.call_end_outlined,
                    iconColor: Colors.red,
                    title: 'Call Again to Stop',
                    description: 'Give another missed call to stop the motor.',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Access Restriction Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Colors.amber,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Access Restriction',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB45309),
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(text: 'Only numbers listed in '),
                              TextSpan(
                                text: 'Authorized Numbers',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' can control the motor using missed calls.'),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildTimelineStep({
    required String stepNumber,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: badgeBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast) ...[
              const SizedBox(height: 4),
              Column(
                children: List.generate(4, (index) => Container(
                  width: 1.5,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: const Color(0xFFCBD5E1),
                )),
              ),
              const SizedBox(height: 4),
            ],
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: textGrey,
                  height: 1.4,
                ),
              ),
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

/// 3. Shared Dialogs - Sending Command
class _SendingCommandDialog extends StatelessWidget {
  final String actionText;
  final VoidCallback onCancel;

  const _SendingCommandDialog({
    required this.actionText,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const loaderBg = Color(0xFFE8F0FE);
    const loaderColor = Color(0xFF2F66F6);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);
    const borderSlateGrey = Color(0xFFCBD5E1);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: loaderBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sending Command',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              actionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSlate,
                  side: const BorderSide(color: borderSlateGrey, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. Shared Dialogs - Command Failed
class _CommandFailedDialog extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onCancel;

  const _CommandFailedDialog({
    required this.onTryAgain,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    const errorBg = Color(0xFFFFF4EC);
    const errorOrange = Color(0xFFE27F00);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);
    const borderSlateGrey = Color(0xFFCBD5E1);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: errorBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.report_problem_outlined,
                  color: errorOrange,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Command Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not send SMS command to device. Please check your network and try again. Please check your network or SIM settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            PrimaryGradientButton(
              label: 'Try Again',
              onPressed: onTryAgain,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textSlate,
                  side: const BorderSide(color: borderSlateGrey, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. Shared Dialogs - Command Success
class _CommandSuccessDialog extends StatelessWidget {
  final String? contextLabel;
  final String title;
  final String body;
  final VoidCallback onOk;

  const _CommandSuccessDialog({
    this.contextLabel,
    required this.title,
    required this.body,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    const successBg = Color(0xFFE6F7ED);
    const successGreen = Color(0xFF00A859);
    const textSlate = Color(0xFF0F172A);
    const textSlateGrey = Color(0xFF64748B);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: successBg,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: successGreen,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (contextLabel != null) ...[
              Text(
                contextLabel!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textSlate,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: textSlateGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            PrimaryGradientButton(
              label: 'OK',
              onPressed: onOk,
            ),
          ],
        ),
      ),
    );
  }
}
