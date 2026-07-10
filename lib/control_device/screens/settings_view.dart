import 'package:flutter/material.dart';
import '../settings/star_delta_timer/star_delta_timer_screen.dart';
import '../settings/ct_sensor/ct_sensor_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'authorized_numbers.dart';
import '../settings/screens/missed-call-mode.dart';
import '../settings/screens/start-type.dart';
import '../settings/screens/voltage_protection_screen.dart';
import '../settings/screens/current_protection_screen.dart';
import '../settings/screens/sim_balance_screen.dart';

const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // 1. Last Known Status Card
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
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: blueBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: blueColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Last Known Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Text(
                          'Updated via device response',
                          style: TextStyle(fontSize: 12, color: textGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Last Synced pill tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: textGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Last synced 2h ago',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Status rows
              _buildStatusRow('Voltage Protection', 'Last set: Enabled'),
              const SizedBox(height: 10),
              _buildStatusRow('Current Range', 'Last set: 4.5A – 7A'),
              const SizedBox(height: 10),
              _buildStatusRow('SIM Balance', 'Last received: ₹24.50'),
              const SizedBox(height: 16),

              const Divider(height: 1),
              const SizedBox(height: 12),
              const Text(
                'Device updates are received via SMS or call. Status may not be real-time.',
                style: TextStyle(fontSize: 12, color: textGrey, height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Quick Settings Header
        const Text(
          'Quick Settings',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Quick Settings Grid of Cards
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: [
            _buildGridCard(
              icon: Icons.bolt,
              iconColor: primaryGreen,
              iconBgColor: const Color(0xFFE6F7ED),
              title: 'Starter Type',
              value: 'Single Phase',
              subtitle: 'Last set: Single Phase',
              footer: 'Sent at: 5:00pm 12/03/2026',
            ),
            _buildGridCard(
              icon: Icons.show_chart,
              iconColor: Colors.orange,
              iconBgColor: const Color(0xFFFFF4EC),
              title: 'Voltage Setting',
              value: '230V',
              subtitle: 'Last set: 230V',
              footer: 'Sent at: 3:30pm 18/03/2026',
            ),
            _buildGridCard(
              icon: Icons.center_focus_strong_outlined,
              iconColor: blueColor,
              iconBgColor: blueBg,
              title: 'CT Sensor',
              value: '30A',
              subtitle: 'Last set: 30A',
              footer: 'Sent at: 4:15pm 10/03/2026',
            ),
            _buildGridCard(
              icon: Icons.phone_callback,
              iconColor: const Color(0xFFDB2777),
              iconBgColor: const Color(0xFFFDF2F8),
              title: 'Missed Call',
              value: 'Enabled',
              subtitle: 'Last set: Enabled',
              footer: 'Sent at: 2:45pm 15/03/2026',
            ),
            _buildGridCard(
              icon: Icons.speed,
              iconColor: blueColor,
              iconBgColor: blueBg,
              title: 'Current Range',
              value: '4.5A – 7A',
              subtitle: 'Last set: 4.5A – 7A',
              footer: 'Sent at: 11:20am 17/03/2026',
            ),
            _buildGridCard(
              icon: Icons.timer_outlined,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFFEF3C7),
              title: 'Star-Delta Timer',
              value: '30 sec',
              subtitle: 'Last set: 30 sec',
              footer: 'Sent at: 9:00am 08/03/2026',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // SIM Balance Grid card (takes full width)
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SimBalanceScreen()),
            );
          },
          child: _buildGridCardFullWidth(
            icon: Icons.sim_card_outlined,
            iconColor: primaryGreen,
            iconBgColor: const Color(0xFFE6F7ED),
            title: 'SIM Balance',
            value: '₹24.50',
            subtitle: 'Last received: ₹24.50',
            footer: 'Received at: 6:30pm 16/03/2026',
          ),
        ),
        const SizedBox(height: 24),

        // Group 1: DEVICE ACCESS
        _buildCategoryHeader('DEVICE ACCESS'),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AuthorizedNumbersScreen(),
              ),
            );
          },
          child: _buildSettingsMenuCard(
            icon: Icons.people_outline,
            iconColor: blueColor,
            iconBgColor: blueBg,
            title: 'Authorized Numbers',
            description: 'Manage phone numbers allowed to control the device.',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MissedCallModeScreen(),
              ),
            );
          },
          child: _buildSettingsMenuCard(
            icon: Icons.phone_callback_outlined,
            iconColor: const Color(0xFF7C3AED),
            iconBgColor: const Color(0xFFF5F3FF),
            title: 'Missed Call Mode',
            description: 'Enable motor control using missed calls.',
          ),
        ),
        const SizedBox(height: 16),

        // Group 2: MOTOR CONFIGURATION
        _buildCategoryHeader('MOTOR CONFIGURATION'),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const StarterTypeScreen(),
              ),
            );
          },
          child: _buildSettingsMenuCard(
            icon: Icons.settings_outlined,
            iconColor: primaryGreen,
            iconBgColor: const Color(0xFFE6F7ED),
            title: 'Starter Type',
            description: 'Configure motor starter type (Direct / Star-Delta).',
          ),
        ),
        _buildSettingsMenuCard(
          icon: Icons.av_timer,
          iconColor: const Color(0xFFEA580C),
          iconBgColor: const Color(0xFFFFF2EB),
          title: 'Star-Delta Timer',
          description: 'Set delay between star and delta mode.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StarDeltaTimerScreen(
                  onBackPressed: () => Navigator.pop(context),
                  onSaveSettings: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        _buildSettingsMenuCard(
          icon: Icons.graphic_eq,
          iconColor: blueColor,
          iconBgColor: blueBg,
          title: 'CT Sensor',
          description: 'Enable or configure current transformer sensor.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CtSensorScreen(
                  onBackPressed: () => Navigator.pop(context),
                  onSaveSettings: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Group 3: PROTECTION SETTINGS
        _buildCategoryHeader('PROTECTION SETTINGS'),
        _buildSettingsMenuCard(
          icon: Icons.flash_on_outlined,
          iconColor: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFEF3C7),
          title: 'Voltage Protection',
          description: 'Set minimum and maximum voltage limits.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const VoltageProtectionScreen(),
              ),
            );
          },
        ),
        _buildSettingsMenuCard(
          icon: Icons.error_outline_rounded,
          iconColor: const Color(0xFFEF4444),
          iconBgColor: const Color(0xFFFEE2E2),
          title: 'Current Protection',
          description: 'Set motor current safety limits.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CurrentProtectionScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Group 4: SIM INFORMATION
        _buildCategoryHeader('SIM INFORMATION'),
        _buildSettingsMenuCard(
          icon: Icons.phone_android_outlined,
          iconColor: const Color(0xFF0D9488),
          iconBgColor: const Color(0xFFF0FDFA),
          title: 'SIM Balance',
          description:
              'Check remaining balance of the SIM card inside the device.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SimBalanceScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: textGrey)),
        Text(
          val,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
    required String footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11, color: textGrey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const Spacer(),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: textGrey)),
          Text(footer, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGridCardFullWidth({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
    required String footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: textGrey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: textGrey),
              ),
              Text(
                footer,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textGrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsMenuCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderGrey),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
