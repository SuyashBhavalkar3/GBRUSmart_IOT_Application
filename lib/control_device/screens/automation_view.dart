import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/automation_provider.dart';
import 'auto_start_config_screen.dart';
import 'run_once_config_screen.dart';
import 'daily_schedule_config_screen.dart';
import 'cyclic_mode_config_screen.dart';

class AutomationView extends ConsumerWidget {
  const AutomationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final automationState = ref.watch(automationProvider);
    final notifier = ref.read(automationProvider.notifier);

    // Styling constants
    const textGrey = Color(0xFF666666);

    const orangeColor = Color(0xFFE27F00);
    const orangeBg = Color(0xFFFFF4EC);
    const blueColor = Color(0xFF2F66F6);
    const blueBg = Color(0xFFEEF3FF);
    const greenColor = Color(0xFF00A859);
    const greenBg = Color(0xFFE6F7ED);
    const greyColor = Color(0xFF888888);
    const greyBg = Color(0xFFF0F0F0);
    const purpleColor = Color(0xFF9C27B0);
    const purpleBg = Color(0xFFF9F0FA);

    return Column(
      children: [
        // 1. Auto Start After Power Return
        _buildAutomationCard(
          icon: Icons.flash_on_rounded,
          iconColor: orangeColor,
          iconBgColor: orangeBg,
          title: 'Auto Start After Power Return',
          subtitle: 'Automatically start motor when electricity returns.',
          isEnabled: automationState.autoStartEnabled,
          onToggle: notifier.toggleAutoStart,
          actionButtonLabel: 'Configure',
          onActionPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AutoStartConfigScreen(),
              ),
            );
          },
          extraWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: blueBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 16, color: blueColor),
                const SizedBox(width: 6),
                Text(
                  'Delay: ${automationState.autoStartDelay} seconds',
                  style: const TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Run Once Timer
        _buildAutomationCard(
          icon: Icons.timer_outlined,
          iconColor: orangeColor,
          iconBgColor: orangeBg,
          title: 'Run Once Timer',
          subtitle: 'Run the motor once for a fixed time.',
          isEnabled: automationState.runOnceTimerEnabled,
          onToggle: notifier.toggleRunOnceTimer,
          actionButtonLabel: 'Start Timer',
          onActionPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RunOnceConfigScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // 3. Daily Schedule
        _buildAutomationCard(
          icon: Icons.calendar_today_outlined,
          iconColor: blueColor,
          iconBgColor: blueBg,
          title: 'Daily Schedule',
          subtitle: 'Run the motor automatically for a fixed time and days.',
          isEnabled: automationState.dailyScheduleEnabled,
          onToggle: notifier.toggleDailySchedule,
          actionButtonLabel: 'Configure',
          onActionPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DailyScheduleConfigScreen(),
              ),
            );
          },
          extraWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: automationState.dailyScheduleEnabled ? greenBg : greyBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    (automationState.dailyScheduleEnabled
                            ? greenColor
                            : greyColor)
                        .withAlpha(50),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: automationState.dailyScheduleEnabled
                        ? greenColor
                        : greyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  automationState.dailyScheduleStatus,
                  style: TextStyle(
                    color: automationState.dailyScheduleEnabled
                        ? greenColor
                        : textGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 4. Cyclic Mode
        _buildAutomationCard(
          icon: Icons.repeat_rounded,
          iconColor: purpleColor,
          iconBgColor: purpleBg,
          title: 'Cyclic Mode',
          subtitle: 'Run the motor continuously in ON and OFF cycles.',
          isEnabled: automationState.cyclicModeEnabled,
          onToggle: notifier.toggleCyclicMode,
          actionButtonLabel: 'Configure',
          onActionPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CyclicModeConfigScreen(),
              ),
            );
          },
          extraWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: automationState.cyclicModeEnabled ? greenBg : greyBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    (automationState.cyclicModeEnabled ? greenColor : greyColor)
                        .withAlpha(50),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: automationState.cyclicModeEnabled
                        ? greenColor
                        : greyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  automationState.cyclicModeEnabled ? "Active" : "Inactive",
                  style: TextStyle(
                    color: automationState.cyclicModeEnabled
                        ? greenColor
                        : textGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAutomationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
    required String actionButtonLabel,
    required VoidCallback onActionPressed,
    Widget? extraWidget,
  }) {
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF666666);
    const primaryGreen = Color(0xFF00A859);

    return Container(
      padding: const EdgeInsets.all(16),
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
              // Icon block
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              // Text Block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Switch
              Switch(
                value: isEnabled,
                activeThumbColor: Colors.white,
                activeTrackColor: primaryGreen,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
                onChanged: onToggle,
              ),
            ],
          ),
          if (extraWidget != null) ...[const SizedBox(height: 14), extraWidget],
          const SizedBox(height: 16),
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                actionButtonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
