import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/automation_provider.dart';
import '../models/automation_state.dart';

const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

final showScheduleFormProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

class DailyScheduleConfigScreen extends ConsumerWidget {
  const DailyScheduleConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(automationProvider);
    final notifier = ref.read(automationProvider.notifier);
    final showForm = ref.watch(showScheduleFormProvider);

    // Dialog state listener
    ref.listen<AutomationState>(automationProvider, (previous, next) {
      if (next.dailySendingCommand &&
          !(previous?.dailySendingCommand ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _SendingAutomationCommandDialog(),
        );
      } else if (!next.dailySendingCommand &&
          (previous?.dailySendingCommand ?? false)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (next.dailyShowSuccess && !(previous?.dailyShowSuccess ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _AutomationCommandSentDialog(),
        ).then((_) {
          // Close the form view upon successful creation
          ref.read(showScheduleFormProvider.notifier).state = false;
        });
      }

      if (next.dailyShowFailure && !(previous?.dailyShowFailure ?? false)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _CommandFailedDialog(),
        );
      }
    });

    final formattedHours = state.scheduleHours.toString().padLeft(2, '0');
    final formattedMinutes = state.scheduleMinutes.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: bgMint,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () {
            if (showForm) {
              ref.read(showScheduleFormProvider.notifier).state = false;
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          showForm ? 'Create Schedule' : 'Daily Schedule',
          style: const TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Subheader Tab indicator
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
                            'Automation',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main body
            Expanded(
              child: () {
                if (showForm) {
                  return _buildScheduleForm(
                    context,
                    ref,
                    state,
                    notifier,
                    formattedHours,
                    formattedMinutes,
                  );
                } else if (!state.dailyScheduleCreated) {
                  return _buildEmptyState(ref);
                } else {
                  return _buildActiveScheduleList(ref, state, notifier);
                }
              }(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textGrey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'My Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Knowledge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // 1. Empty State View
  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_filled_rounded,
                color: Colors.grey,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Schedule not set yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(showScheduleFormProvider.notifier).state = true;
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create First Schedule',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A859),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Active List View
  Widget _buildActiveScheduleList(
    WidgetRef ref,
    AutomationState state,
    AutomationNotifier notifier,
  ) {
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF666666);
    const greenBg = Color(0xFFE6F7ED);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.scheduleName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      Switch(
                        value: state.dailyScheduleEnabled,
                        activeThumbColor: Colors.white,
                        activeTrackColor: primaryGreen,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                        onChanged: notifier.toggleDailySchedule,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        color: primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.scheduleHours.toString().padLeft(2, '0')}hrs and ${state.scheduleMinutes.toString().padLeft(2, '0')}mins',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Days:',
                    style: TextStyle(fontSize: 12, color: textGrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${state.scheduleDays} Days',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: state.dailyScheduleEnabled
                              ? greenBg
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: state.dailyScheduleEnabled
                                ? primaryGreen.withAlpha(50)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: state.dailyScheduleEnabled
                                    ? primaryGreen
                                    : textGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.dailyScheduleEnabled
                                  ? 'Active'
                                  : 'Inactive',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: state.dailyScheduleEnabled
                                    ? primaryGreen
                                    : textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => notifier.deleteDailySchedule(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton.extended(
            onPressed: () {
              ref.read(showScheduleFormProvider.notifier).state = true;
            },
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text(
              'Add Schedule',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Create/Edit Schedule Form
  Widget _buildScheduleForm(
    BuildContext context,
    WidgetRef ref,
    AutomationState state,
    AutomationNotifier notifier,
    String formattedHours,
    String formattedMinutes,
  ) {
    final controller = TextEditingController(text: state.scheduleName);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Schedule Name Box
        const Text(
          'Schedule Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: notifier.updateScheduleName,
          decoration: InputDecoration(
            hintText: 'Morning Irrigation',
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Run Motor Duration
        Row(
          children: [
            const Icon(Icons.access_time, color: textGrey, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Run Motor Duration',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Adjuster Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderGrey),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours
                  Column(
                    children: [
                      const Text(
                        'Hour',
                        style: TextStyle(fontSize: 11, color: textGrey),
                      ),
                      const SizedBox(height: 6),
                      _buildValueBox(formattedHours),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniAdjustButton(
                            Icons.remove,
                            notifier.decrementScheduleHours,
                          ),
                          const SizedBox(width: 8),
                          _buildMiniAdjustButton(
                            Icons.add,
                            notifier.incrementScheduleHours,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                  // Minutes
                  Column(
                    children: [
                      const Text(
                        'Minute',
                        style: TextStyle(fontSize: 11, color: textGrey),
                      ),
                      const SizedBox(height: 6),
                      _buildValueBox(formattedMinutes),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniAdjustButton(
                            Icons.remove,
                            notifier.decrementScheduleMinutes,
                          ),
                          const SizedBox(width: 8),
                          _buildMiniAdjustButton(
                            Icons.add,
                            notifier.incrementScheduleMinutes,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: textDark),
                  children: [
                    const TextSpan(text: 'Motor runs for '),
                    TextSpan(
                      text: '${formattedHours}hrs and ${formattedMinutes}mins',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Run For How Many Days
        const Text(
          'Run For How Many Days',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const Text(
          'Select how many days this automation should continue.',
          style: TextStyle(fontSize: 12, color: textGrey),
        ),
        const SizedBox(height: 12),

        // Days counter box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderGrey),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleAdjustButton(
                    Icons.remove,
                    notifier.decrementScheduleDays,
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text(
                        '${state.scheduleDays}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      const Text(
                        'Days',
                        style: TextStyle(fontSize: 11, color: textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  _buildCircleAdjustButton(
                    Icons.add,
                    notifier.incrementScheduleDays,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Horizontal progress bar representing selected days out of 30 max days
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: state.scheduleDays / 30.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Safety Setting
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: textGrey, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Safety Setting',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stop if dry run detected',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  Switch(
                    value: state.dryRunProtectionEnabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: primaryGreen,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[300],
                    onChanged: notifier.toggleDryRunProtection,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Automatically stops motor when no water flow is detected to prevent damage',
                style: TextStyle(fontSize: 12, color: textGrey, height: 1.3),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.check, color: Colors.orange, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Motor protection enabled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Save Schedule Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => notifier.sendDailyScheduleCommand(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Save Schedule',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Simulation toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Widget _buildMiniAdjustButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Center(
          child: Icon(icon, color: const Color(0xFF1A1A1A), size: 16),
        ),
      ),
    );
  }

  Widget _buildCircleAdjustButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: icon == Icons.add ? const Color(0xFF00A859) : Colors.grey[100],
          shape: BoxShape.circle,
          border: Border.all(
            color: icon == Icons.add
                ? const Color(0xFF00A859)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: icon == Icons.add ? Colors.white : const Color(0xFF1A1A1A),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildValueBox(String val) {
    return Container(
      width: 80,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Center(
        child: Text(
          val,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }
}

// Dialog overlays
class _SendingAutomationCommandDialog extends ConsumerWidget {
  const _SendingAutomationCommandDialog();

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
              'Sending Automation\nCommand',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sending SMS command to\nconfigure motor automation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref
                      .read(automationProvider.notifier)
                      .cancelDailyScheduleCommand();
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

class _AutomationCommandSentDialog extends ConsumerWidget {
  const _AutomationCommandSentDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(automationProvider);
    const successBg = Color(0xFFE6F7ED);
    const successGreen = Color(0xFF00A859);
    const textDark = Color(0xFF0F172A);
    const textGrey = Color(0xFF64748B);

    final hoursPart = state.scheduleHours > 0
        ? '${state.scheduleHours} hours '
        : '';
    final minutesPart = '${state.scheduleMinutes} minutes';

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
              'Automation\nCommand Sent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Motor will run '),
                  TextSpan(
                    text:
                        '$hoursPart$minutesPart daily\nfor ${state.scheduleDays} days.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            const Text(
              'You will receive confirmation via\nSMS on your phone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textGrey, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(automationProvider.notifier)
                      .dismissDailySuccessDialog();
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
              'Unable to send SMS command.\nPlease check your network or\nSIM settings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textGrey, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(automationProvider.notifier)
                      .retryDailyScheduleCommand();
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
                      .read(automationProvider.notifier)
                      .dismissDailyFailureDialog();
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
