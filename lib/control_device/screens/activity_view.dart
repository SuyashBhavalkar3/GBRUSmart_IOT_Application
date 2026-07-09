import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color primaryGreen = Color(0xFF00A859);
const Color bgMint = Color(0xFFF0F9F4);
const Color textDark = Color(0xFF1A1A1A);
const Color textGrey = Color(0xFF666666);
const Color borderGrey = Color(0xFFE0E0E0);
const Color blueColor = Color(0xFF2F66F6);
const Color blueBg = Color(0xFFEEF3FF);
const Color purpleColor = Color(0xFF7C3AED);
const Color purpleBg = Color(0xFFF5F3FF);

class ActivityItem {
  final String title;
  final String description;
  final String status; // 'Sent Successfully' or 'Failed'
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String category; // 'Today', '7 Days', '30 Days'

  ActivityItem({
    required this.title,
    this.description = '',
    required this.status,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.category,
  });
}

final selectedFilterProvider = StateProvider.autoDispose<String>(
  (ref) => 'Today',
);
final selectedDateProvider = StateProvider.autoDispose<int>(
  (ref) => 17,
); // Default highlighted 17 March

class ActivityView extends ConsumerWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedFilterProvider);

    final allActivities = [
      ActivityItem(
        title: 'Start Motor',
        status: 'Sent Successfully',
        time: '10:45 AM Today',
        icon: Icons.bolt_outlined,
        iconColor: blueColor,
        iconBgColor: blueBg,
        category: 'Today',
      ),
      ActivityItem(
        title: 'Daily Timer Set',
        description: '4h 30m daily for 5 days',
        status: 'Sent Successfully',
        time: '9:20 AM Today',
        icon: Icons.access_time_outlined,
        iconColor: purpleColor,
        iconBgColor: purpleBg,
        category: 'Today',
      ),
      ActivityItem(
        title: 'Cyclic Mode Enabled',
        description: 'Run 2h, Stop 1h',
        status: 'Failed',
        time: '8:15 AM Today',
        icon: Icons.access_time_outlined,
        iconColor: purpleColor,
        iconBgColor: purpleBg,
        category: 'Today',
      ),
      ActivityItem(
        title: 'Auto Start Enabled',
        status: 'Sent Successfully',
        time: '6:30 PM Yesterday',
        icon: Icons.settings_outlined,
        iconColor: textGrey,
        iconBgColor: const Color(0xFFF1F5F9),
        category: '7 Days',
      ),
      ActivityItem(
        title: 'Stop Motor',
        status: 'Sent Successfully',
        time: '5:15 PM Yesterday',
        icon: Icons.bolt_outlined,
        iconColor: blueColor,
        iconBgColor: blueBg,
        category: '7 Days',
      ),
      ActivityItem(
        title: 'Check Motor Status',
        status: 'Sent Successfully',
        time: '4:50 PM Yesterday',
        icon: Icons.bolt_outlined,
        iconColor: blueColor,
        iconBgColor: blueBg,
        category: '7 Days',
      ),
      ActivityItem(
        title: 'Daily Timer Set',
        description: '3h daily for 7 days',
        status: 'Failed',
        time: '2:30 PM Yesterday',
        icon: Icons.access_time_outlined,
        iconColor: purpleColor,
        iconBgColor: purpleBg,
        category: '7 Days',
      ),
    ];

    // Filter items based on selected tab
    final filteredActivities = allActivities.where((activity) {
      if (selectedFilter == 'Today') {
        return activity.category == 'Today';
      } else if (selectedFilter == '7 Days') {
        return activity.category == 'Today' || activity.category == '7 Days';
      } else {
        return true;
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderGrey),
                ),
                child: Row(
                  children: [
                    _buildFilterTab(ref, 'Today', selectedFilter),
                    _buildFilterTab(ref, '7 Days', selectedFilter),
                    _buildFilterTab(ref, '30 Days', selectedFilter),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const _SelectDateDialog(),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withAlpha(76),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Activity log items
        Expanded(
          child: ListView.builder(
            itemCount: filteredActivities.length,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final item = filteredActivities[index];
              return _buildActivityCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(WidgetRef ref, String text, String currentSelection) {
    final isSelected = text == currentSelection;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedFilterProvider.notifier).state = text;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(ActivityItem item) {
    final isSuccess = item.status == 'Sent Successfully';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
            ],
          ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(fontSize: 13, color: textGrey),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: isSuccess ? primaryGreen : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSuccess ? primaryGreen : Colors.red,
                    ),
                  ),
                ],
              ),
              Text(
                item.time,
                style: const TextStyle(fontSize: 12, color: textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectDateDialog extends ConsumerWidget {
  const _SelectDateDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDateProvider);
    const dialogDark = Color(0xFF0F172A);
    const dialogGrey = Color(0xFF64748B);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: dialogDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: dialogGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Month Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: dialogGrey),
                  onPressed: () {},
                ),
                const Text(
                  'March 2026',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: dialogDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: dialogGrey),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Weekdays Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _WeekdayLabel('Sun'),
                _WeekdayLabel('Mon'),
                _WeekdayLabel('Tue'),
                _WeekdayLabel('Wed'),
                _WeekdayLabel('Thu'),
                _WeekdayLabel('Fri'),
                _WeekdayLabel('Sat'),
              ],
            ),
            const SizedBox(height: 8),

            // Calendar Grid (mock for March 2026, starting on Sunday March 1)
            Table(
              children: [
                TableRow(
                  children: [
                    _buildDayCell(ref, 1, selectedDay),
                    _buildDayCell(ref, 2, selectedDay),
                    _buildDayCell(ref, 3, selectedDay),
                    _buildDayCell(ref, 4, selectedDay),
                    _buildDayCell(ref, 5, selectedDay),
                    _buildDayCell(ref, 6, selectedDay),
                    _buildDayCell(ref, 7, selectedDay),
                  ],
                ),
                TableRow(
                  children: [
                    _buildDayCell(ref, 8, selectedDay),
                    _buildDayCell(ref, 9, selectedDay),
                    _buildDayCell(ref, 10, selectedDay),
                    _buildDayCell(ref, 11, selectedDay),
                    _buildDayCell(ref, 12, selectedDay),
                    _buildDayCell(ref, 13, selectedDay),
                    _buildDayCell(ref, 14, selectedDay),
                  ],
                ),
                TableRow(
                  children: [
                    _buildDayCell(ref, 15, selectedDay),
                    _buildDayCell(ref, 16, selectedDay),
                    _buildDayCell(ref, 17, selectedDay),
                    _buildDayCell(ref, 18, selectedDay),
                    _buildDayCell(ref, 19, selectedDay),
                    _buildDayCell(ref, 20, selectedDay),
                    _buildDayCell(ref, 21, selectedDay),
                  ],
                ),
                TableRow(
                  children: [
                    _buildDayCell(ref, 22, selectedDay),
                    _buildDayCell(ref, 23, selectedDay),
                    _buildDayCell(ref, 24, selectedDay),
                    _buildDayCell(ref, 25, selectedDay),
                    _buildDayCell(ref, 26, selectedDay),
                    _buildDayCell(ref, 27, selectedDay),
                    _buildDayCell(ref, 28, selectedDay),
                  ],
                ),
                TableRow(
                  children: [
                    _buildDayCell(ref, 29, selectedDay),
                    _buildDayCell(ref, 30, selectedDay),
                    _buildDayCell(ref, 31, selectedDay),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Go to Today Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(selectedDateProvider.notifier).state =
                      17; // mock today March 17
                  ref.read(selectedFilterProvider.notifier).state = 'Today';
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Go to Today',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(WidgetRef ref, int day, int selectedDay) {
    final isSelected = day == selectedDay;
    final isToday = day == 17;

    return GestureDetector(
      onTap: () {
        ref.read(selectedDateProvider.notifier).state = day;
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? primaryGreen : Colors.transparent,
              shape: BoxShape.circle,
              border: (isToday && !isSelected)
                  ? Border.all(color: primaryGreen, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (day > 17 ? Colors.grey[300] : Color(0xFF0F172A)),
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
