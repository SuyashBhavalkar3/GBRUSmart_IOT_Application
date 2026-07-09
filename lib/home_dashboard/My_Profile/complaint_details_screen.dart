import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import '../widgets/mobile_auto/primary_gradient_button.dart';
import 'profile_provider.dart';

/// Screen 16: Dialog showing detailed complaint ticket status and timeline progression.
class ComplaintDetailsScreen extends ConsumerWidget {
  final String ticketNumber;

  const ComplaintDetailsScreen({
    super.key,
    required this.ticketNumber,
  });

  /// Helper to convert a month index to shorthand name.
  static String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  static String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    
    // Find complaint in active or resolved list
    ComplaintModel? complaint;
    final activeIndex = profileState.activeComplaints.indexWhere((c) => c.ticketNumber == ticketNumber);
    if (activeIndex >= 0) {
      complaint = profileState.activeComplaints[activeIndex];
    } else {
      final resolvedIndex = profileState.resolvedComplaints.indexWhere((c) => c.ticketNumber == ticketNumber);
      if (resolvedIndex >= 0) {
        complaint = profileState.resolvedComplaints[resolvedIndex];
      }
    }

    if (complaint == null) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Complaint not found'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    }

    final isResolved = complaint.status == 'Resolved';

    // Status Badge colors
    Color badgeBg;
    Color badgeTxt;
    if (isResolved) {
      badgeBg = const Color(0xFFE8F5E9);
      badgeTxt = AppColors.primaryGreen;
    } else if (complaint.status == 'Escalated') {
      badgeBg = const Color(0xFFFFF3E0);
      badgeTxt = const Color(0xFFE65100);
    } else {
      badgeBg = const Color(0xFFE3F2FD);
      badgeTxt = const Color(0xFF1E88E5);
    }

    // Priority color
    Color priorityColor;
    if (complaint.priority == 'High') {
      priorityColor = AppColors.errorRed;
    } else if (complaint.priority == 'Medium') {
      priorityColor = const Color(0xFFE65100);
    } else {
      priorityColor = AppColors.primaryGreen;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  // Title + Icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isResolved ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isResolved ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                          color: isResolved ? AppColors.primaryGreen : const Color(0xFFE65100),
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complaint.title,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              complaint.ticketNumber,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      complaint.status,
                      style: TextStyle(
                        color: badgeTxt,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Description paragraph
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    complaint.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Info grid visual
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FBF7),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Column(
                      children: [
                        _buildGridRow('Date Submitted', _formatDate(complaint.submittedDate)),
                        const Divider(height: 16.0, color: AppColors.borderGrey),
                        _buildGridRow('Category', complaint.category),
                        const Divider(height: 16.0, color: AppColors.borderGrey),
                        _buildGridRow(
                          'Priority',
                          complaint.priority,
                          valueStyle: TextStyle(
                            color: priorityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Timeline Section
                  const Text(
                    'Activity Timeline',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  
                  // Render Timeline Items
                  _buildTimeline(complaint.timeline),
                  const SizedBox(height: 24.0),

                  // Action Button
                  PrimaryGradientButton(
                    label: isResolved ? 'Close' : 'Resolve Ticket',
                    onPressed: () {
                      if (!isResolved) {
                        ref.read(profileProvider.notifier).updateComplaintStatus(ticketNumber, 'Resolved');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket marked as Resolved!'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Close Icon top-right
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textGrey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridRow(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.0, color: AppColors.textGrey, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: valueStyle ?? const TextStyle(fontSize: 12.0, color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimeline(List<ComplaintTimelineEntry> timeline) {
    return Column(
      children: List.generate(timeline.length, (index) {
        final entry = timeline[index];
        final isLast = index == timeline.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.0,
                    height: 36.0,
                    color: AppColors.borderGrey,
                  ),
              ],
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${_formatDate(entry.timestamp)} at ${_formatTime(entry.timestamp)}',
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
