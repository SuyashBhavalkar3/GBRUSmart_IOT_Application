import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voltage_settings_provider.dart';

const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

class VoltageProtectionScreen extends ConsumerWidget {
  const VoltageProtectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voltageSettingsProvider);
    final notifier = ref.read(voltageSettingsProvider.notifier);

    // Dialog state listener
    ref.listen<VoltageSettingsState>(voltageSettingsProvider, (previous, next) {
      if (next.isSending && !(previous?.isSending ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _SendingCommandDialog(),
        );
      } else if (!next.isSending && (previous?.isSending ?? false)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (next.showSuccess && !(previous?.showSuccess ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _CommandSentSuccessDialog(),
        );
      }

      if (next.showFailure && !(previous?.showFailure ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _CommandFailedDialog(),
        );
      }
    });

    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Set Voltage',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Configure voltage value for the device',
              style: TextStyle(fontSize: 11, color: textGrey),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Subheader Tab Navigation Indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Control',
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Automation',
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Activity',
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGreen.withAlpha(76),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable parameters content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Voltage Value Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF9E6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.flash_on,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Voltage Value',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Set the voltage parameter according to your motor and electrical supply.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textGrey,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Large green selector box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderGrey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildAdjustButton(
                                  Icons.remove,
                                  notifier.decrementVoltage,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${state.voltageValue}',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: primaryGreen,
                                        height: 1.1,
                                      ),
                                    ),
                                    const Text(
                                      'Volts',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: borderGrey),
                                      ),
                                      child: const Text(
                                        'Range: 110V - 440V',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: textGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildAdjustButton(
                                  Icons.add,
                                  notifier.incrementVoltage,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Presets
                          const Text(
                            'Quick presets:',
                            style: TextStyle(
                              fontSize: 12,
                              color: textGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPresetBtn(
                                '110V',
                                110,
                                state.voltageValue,
                                notifier,
                              ),
                              _buildPresetBtn(
                                '230V',
                                230,
                                state.voltageValue,
                                notifier,
                              ),
                              _buildPresetBtn(
                                '415V',
                                415,
                                state.voltageValue,
                                notifier,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Note Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: blueBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: blueColor.withAlpha(50)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: blueColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Note',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: blueColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Correct voltage configuration ensures proper motor operation and prevents electrical issues. Always match the voltage setting with your local power supply.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF475569),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Testing Simulation Switch
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.withAlpha(76)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.bug_report, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Simulate Command Failure (Testing)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: state.simulateFailure,
                            activeThumbColor: Colors.amber,
                            onChanged: notifier.toggleSimulateFailure,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions Box
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => notifier.sendVoltageCommand(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Device configuration will be updated after saving.',
                    style: TextStyle(fontSize: 11, color: textGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: textDark, size: 20)),
      ),
    );
  }

  Widget _buildPresetBtn(
    String label,
    int value,
    int currentValue,
    VoltageSettingsNotifier notifier,
  ) {
    final isSelected = value == currentValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.setPresetVoltage(value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primaryGreen : borderGrey),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textDark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Dialog overlays
class _SendingCommandDialog extends ConsumerWidget {
  const _SendingCommandDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voltageSettingsProvider);
    const loaderBg = Color(0xFFE8F0FE);
    const loaderColor = Color(0xFF2F66F6);
    const textDark = Color(0xFF0F172A);
    const textGrey = Color(0xFF64748B);
    const borderGrey = Color(0xFFCBD5E1);

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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${state.voltageValue} Volts',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref
                      .read(voltageSettingsProvider.notifier)
                      .cancelVoltageCommand();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textDark,
                  side: const BorderSide(color: borderGrey, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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

class _CommandSentSuccessDialog extends ConsumerWidget {
  const _CommandSentSuccessDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const successBg = Color(0xFFE6F7ED);
    const successGreen = Color(0xFF00A859);
    const textDark = Color(0xFF0F172A);
    const textGrey = Color(0xFF64748B);

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
                child: Icon(Icons.check_circle, color: successGreen, size: 36),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Command Sent\nSuccessfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'command has been sent to the device.\nYou will receive confirmation via\nSMS on your phone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textGrey, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(voltageSettingsProvider.notifier)
                      .dismissVoltageSuccessDialog();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandFailedDialog extends ConsumerWidget {
  const _CommandFailedDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const errorBg = Color(0xFFFFF4EC);
    const errorOrange = Color(0xFFE27F00);
    const successGreen = Color(0xFF00A859);
    const textDark = Color(0xFF0F172A);
    const textGrey = Color(0xFF64748B);
    const borderGrey = Color(0xFFCBD5E1);

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
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not send SMS command to device. Please check your network and try again. Please check your network or SIM settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(voltageSettingsProvider.notifier)
                      .retryVoltageCommand();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref
                      .read(voltageSettingsProvider.notifier)
                      .dismissVoltageFailureDialog();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textDark,
                  side: const BorderSide(color: borderGrey, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
