import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sim_balance_provider.dart';

const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

class SimBalanceScreen extends ConsumerWidget {
  const SimBalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simBalanceProvider);
    final notifier = ref.read(simBalanceProvider.notifier);

    final isLowBalance = state.simBalance < 20.0;

    // Dialog state listener
    ref.listen<SimBalanceState>(simBalanceProvider, (previous, next) {
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
              'SIM Balance',
              style: TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Check the SIM balance of your device',
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

            // Scrollable SIM Balance details content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Available SIM Balance Card
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
                        children: [
                          // SIM Card green graphic circle icon
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.phone_android_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Large balance display
                          Text(
                            '₹ ${state.simBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Available SIM Balance',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textGrey,
                            ),
                          ),
                          Text(
                            'Last updated: ${state.lastUpdated}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: textGrey,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Dynamic Tag (Sufficient vs Low)
                          if (!isLowBalance)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F7ED),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: primaryGreen,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Sufficient Balance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.report_problem_outlined,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Low Balance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Check Balance Refresh Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => notifier.checkBalance(),
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Check Balance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap to request latest SIM balance from device',
                      style: TextStyle(fontSize: 12, color: textGrey),
                    ),
                    const SizedBox(height: 16),

                    // Conditionally displayed Low SIM Balance Card
                    if (isLowBalance) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.orange.withAlpha(80),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF4EC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Low SIM Balance',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Please recharge the device SIM to ensure uninterrupted communication and timely alerts.',
                              style: TextStyle(
                                fontSize: 12,
                                color: textGrey,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.withAlpha(50),
                                ),
                              ),
                              child: const Text(
                                'Recommended minimum: ₹20\nCurrent balance: ₹12.50',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 2. SIM Information Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.sim_card_outlined,
                                color: textGrey,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'SIM Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSimInfoRow('SIM Number', state.simNumber),
                          const Divider(height: 20),
                          _buildSimInfoRow('Provider', state.provider),
                          const Divider(height: 20),
                          _buildSimInfoRow('Plan Type', state.planType),
                          const Divider(height: 20),
                          _buildSimInfoRow(
                            'Signal Strength',
                            state.signalStrength,
                            trailingIcon: const Icon(
                              Icons.signal_cellular_alt,
                              color: primaryGreen,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. How to Recharge Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFDDD6FE)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFF7C3AED),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'How to Recharge',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'To recharge the device SIM card:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B21A8),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildRechargeStep(
                            1,
                            'Use the SIM number shown above',
                          ),
                          const SizedBox(height: 10),
                          _buildRechargeStep(
                            2,
                            'Recharge via mobile app or retailer',
                          ),
                          const SizedBox(height: 10),
                          _buildRechargeStep(
                            3,
                            'Check balance again after 5 minutes',
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
                      onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildSimInfoRow(String label, String value, {Widget? trailingIcon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: textGrey)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingIcon != null) ...[
              trailingIcon,
              const SizedBox(width: 6),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRechargeStep(int index, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFFDDD6FE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C3AED),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B21A8),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

// Dialog overlays
class _SendingCommandDialog extends ConsumerWidget {
  const _SendingCommandDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const Text(
              'Check SIM Balance',
              style: TextStyle(
                fontSize: 14,
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
                      .read(simBalanceProvider.notifier)
                      .cancelSimBalanceCommand();
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
                      .read(simBalanceProvider.notifier)
                      .dismissSimBalanceSuccessDialog();
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
                      .read(simBalanceProvider.notifier)
                      .retrySimBalanceCommand();
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
                      .read(simBalanceProvider.notifier)
                      .dismissSimBalanceFailureDialog();
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
