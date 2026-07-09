import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import 'profile_provider.dart';

/// Screen 14: Custom notifications view displaying alert items, timestamps, and toggles.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final pushEnabled = profileState.notificationPreferences['Push Notifications'] ?? true;

    // Static list of past notifications exactly mirroring the screenshot
    final notificationFeed = [
      {
        'title': 'Dry Run Protection Activated',
        'subtitle': 'Motor stopped automatically due to low water level detected in Borewell',
        'device': 'Borewell Pump',
        'time': '10 mins ago',
        'icon': Icons.water_drop_outlined,
        'iconColor': const Color(0xFFE53935),
        'iconBg': const Color(0xFFFFEBEE),
        'unread': true,
      },
      {
        'title': 'Motor Started Successfully',
        'subtitle': 'Your scheduled irrigation has started at 6:00 AM as per daily schedule.',
        'device': 'Borewell Pump',
        'time': '2 hours ago',
        'icon': Icons.check_circle_outline_rounded,
        'iconColor': const Color(0xFF1FAA59),
        'iconBg': const Color(0xFFE8F5E9),
        'unread': true,
      },
      {
        'title': 'Schedule Completed',
        'subtitle': 'Daily Schedule "Morning Irrigation" completed successfully. Runtime: 2h',
        'device': 'Borewell Pump',
        'time': '4 hours ago',
        'icon': Icons.calendar_today_outlined,
        'iconColor': const Color(0xFF555555),
        'iconBg': const Color(0xFFF5F5F5),
        'unread': false,
      },
      {
        'title': 'High Current Detected',
        'subtitle': 'Motor current exceeded normal range (12.5A). Please check motor',
        'device': 'Borewell Pump',
        'time': '1 day ago',
        'icon': Icons.bolt_outlined,
        'iconColor': const Color(0xFFE53935),
        'iconBg': const Color(0xFFFFEBEE),
        'unread': false,
      },
      {
        'title': 'Device Connected',
        'subtitle': 'Mobile Auto device is now online and ready to use.',
        'device': 'Borewell Pump',
        'time': '2 days ago',
        'icon': Icons.check_circle_outline_rounded,
        'iconColor': const Color(0xFF1FAA59),
        'iconBg': const Color(0xFFE8F5E9),
        'unread': false,
      },
      {
        'title': 'Cycle Mode Running',
        'subtitle': 'Cycle 3 of 5 completed. Next cycle starts in 1 hour 30 minutes.',
        'device': 'Borewell Pump',
        'time': '2 days ago',
        'icon': Icons.access_time_rounded,
        'iconColor': const Color(0xFF555555),
        'iconBg': const Color(0xFFF5F5F5),
        'unread': false,
      },
      {
        'title': 'Power Supply Interrupted',
        'subtitle': 'Main power supply disconnected. Motor stopped automatically.',
        'device': 'Borewell Pump',
        'time': '3 days ago',
        'icon': Icons.warning_amber_rounded,
        'iconColor': const Color(0xFFE53935),
        'iconBg': const Color(0xFFFFEBEE),
        'unread': false,
      },
      {
        'title': 'Weekly Report Available',
        'subtitle': 'Your weekly motor usage report is ready. Total runtime: 18h 45m this',
        'device': '',
        'time': '5 days ago',
        'icon': Icons.trending_up_rounded,
        'iconColor': const Color(0xFF555555),
        'iconBg': const Color(0xFFF5F5F5),
        'unread': false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEBF7F1), // Custom light green background color
      body: SafeArea(
        child: Column(
          children: [
            // Custom White Header Bar matching screenshot
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circular Back Arrow Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF5F5F5),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textDark,
                            size: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 44.0),
                    child: Text(
                      'Choose your preferred langugae', // Match exact text / typo from mock mockup
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Notifications Feed
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Push Notifications Config Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xFF1FAA59),
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Push Notifications',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                pushEnabled ? 'Enabled' : 'Disabled',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: pushEnabled,
                          activeThumbColor: const Color(0xFF1FAA59),
                          activeTrackColor: const Color(0xFF81C784),
                          inactiveThumbColor: AppColors.textGrey,
                          inactiveTrackColor: AppColors.borderGrey,
                          onChanged: (newVal) {
                            ref.read(profileProvider.notifier).toggleNotification('Push Notifications', newVal);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Past Notifications List
                  ...notificationFeed.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left alert category icon
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: item['iconBg'] as Color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['iconColor'] as Color,
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 14.0),

                            // Center content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      // Unread indicator dot
                                      if (item['unread'] as bool)
                                        Container(
                                          width: 8.0,
                                          height: 8.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF1FAA59),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    item['subtitle'] as String,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.textGrey,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),

                                  // Device + time bottom labels
                                  Row(
                                    children: [
                                      if ((item['device'] as String).isNotEmpty) ...[
                                        Text(
                                          item['device'] as String,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF1FAA59),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          '  •  ',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                      Text(
                                        item['time'] as String,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
