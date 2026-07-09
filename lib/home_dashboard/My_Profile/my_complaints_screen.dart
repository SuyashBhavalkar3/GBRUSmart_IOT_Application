import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import '../widgets/mobile_auto/primary_gradient_button.dart';
import 'profile_provider.dart';
import 'complaint_details_screen.dart';
import 'raise_complaint_screen.dart';

/// Screen 15: Complaints Hub page showing both active (In Progress / Escalated) and closed tickets.
class MyComplaintsScreen extends ConsumerWidget {
  const MyComplaintsScreen({super.key});

  /// Helper to convert a month index to shorthand name.
  static String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  static String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final activeList = profileState.activeComplaints;
    final resolvedList = profileState.resolvedComplaints;

    final activeCount = activeList.length;
    final resolvedCount = resolvedList.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Complaints',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active complaint count subtext
              Text(
                'You have $activeCount active complaints',
                style: const TextStyle(fontSize: 13.0, color: AppColors.textGrey),
              ),
              const SizedBox(height: 20.0),

              // Raise New Complaint Button
              PrimaryGradientButton(
                label: 'Raise New Complaint',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RaiseComplaintScreen()),
                  );
                },
              ),
              const SizedBox(height: 24.0),

              // Active Complaints Section
              const Text(
                'Active Complaints',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 12.0),
              
              if (activeList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'No active complaints found.',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13.0),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final complaint = activeList[index];
                    return _ComplaintCard(
                      complaint: complaint,
                      onTapDetails: () => _openDetailsDialog(context, complaint.ticketNumber),
                    );
                  },
                ),
              const SizedBox(height: 28.0),

              // Resolved & Closed Section
              Text(
                'Resolved & Closed ($resolvedCount)',
                style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 12.0),

              if (resolvedList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'No resolved complaints found.',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13.0),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resolvedList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final complaint = resolvedList[index];
                    return _ComplaintCard(
                      complaint: complaint,
                      isMuted: true,
                      onTapDetails: () => _openDetailsDialog(context, complaint.ticketNumber),
                    );
                  },
                ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetailsDialog(BuildContext context, String ticketNumber) {
    showDialog(
      context: context,
      builder: (context) => ComplaintDetailsScreen(ticketNumber: ticketNumber),
    );
  }
}

/// Private card component displaying a summary of a single complaint ticket.
class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final bool isMuted;
  final VoidCallback onTapDetails;

  const _ComplaintCard({
    required this.complaint,
    this.isMuted = false,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color badges
    Color badgeBg;
    Color badgeTxt;
    if (isMuted) {
      badgeBg = const Color(0xFFE8F5E9);
      badgeTxt = AppColors.primaryGreen;
    } else if (complaint.status == 'Escalated') {
      badgeBg = const Color(0xFFFFF3E0);
      badgeTxt = const Color(0xFFE65100);
    } else {
      badgeBg = const Color(0xFFE3F2FD);
      badgeTxt = const Color(0xFF1E88E5);
    }

    final cardOpacity = isMuted ? 0.75 : 1.0;

    return Opacity(
      opacity: cardOpacity,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Ticket number and status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  complaint.ticketNumber,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    complaint.status,
                    style: TextStyle(
                      color: badgeTxt,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            
            // Title
            Text(
              complaint.title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6.0),
            
            // Snippet of description
            Text(
              complaint.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textGrey,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12.0),
            const Divider(height: 1.0, color: AppColors.borderGrey),
            const SizedBox(height: 12.0),

            // Date and action link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isMuted && complaint.resolvedDate != null
                      ? 'Resolved: ${MyComplaintsScreen._formatDate(complaint.resolvedDate!)}'
                      : 'Opened: ${MyComplaintsScreen._formatDate(complaint.submittedDate)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: onTapDetails,
                  child: const Text(
                    'View Details →',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
