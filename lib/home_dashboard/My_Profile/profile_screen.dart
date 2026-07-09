import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_colors.dart';
import '../providers/mobile_auto_provider.dart';
import '../screens/home_dashboard_screen.dart';
import '../../screens/my_devices/my_devices_screen.dart';
import '../Knowledge_hub/knowledge_hub_screen.dart';
import 'profile_provider.dart';
import 'edit_profile_screen.dart';
import 'language_screen.dart';
import 'notifications_screen.dart';
import 'my_complaints_screen.dart';
import 'raise_complaint_screen.dart';

/// Screen 11: Main Profile catalog page displaying user details and links.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final int _currentIndex = 4; // Index 4 is 'Profile'

  Future<void> _callSupport() async {
    final uri = Uri.parse('tel:+9118001234567');
    try {
      await launchUrl(uri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not trigger phone call: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final onboardingState = ref.watch(mobileAutoProvider);

    final totalApproved = onboardingState.approvedDevices.length;
    final totalLinked = onboardingState.linkedDevices.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match light green background tint
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
            );
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
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
              const Text(
                'Manage your account and settings',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 20.0),

              // Profile summary card visual
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: AppColors.lightGreenBg,
                          child: Text(
                            profileState.fullName.isNotEmpty ? profileState.fullName[0] : 'U',
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryGreen,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      profileState.fullName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone_outlined, size: 14.0, color: AppColors.textGrey),
                        const SizedBox(width: 6.0),
                        Text(
                          profileState.phoneNumber,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email_outlined, size: 14.0, color: AppColors.textGrey),
                        const SizedBox(width: 6.0),
                        Text(
                          profileState.email,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Stat Chips Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatChip(
                      icon: Icons.layers_outlined,
                      label: 'Approved Devices',
                      count: totalApproved.toString(),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildStatChip(
                      icon: Icons.share_outlined,
                      label: 'Linked Devices',
                      count: totalLinked.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28.0),

              // Menu sections
              _buildSectionHeader('Account'),
              const SizedBox(height: 8.0),
              _buildMenuCard([
                _ProfileMenuRow(
                  icon: Icons.layers_outlined,
                  title: 'My Devices',
                  subtitle: 'Manage all connected devices',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MyDevicesScreen()),
                    );
                  },
                ),
                _ProfileMenuRow(
                  icon: Icons.phone_android_outlined,
                  title: 'Authorized Numbers',
                  subtitle: 'Manage phone numbers & permissions',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Authorized Numbers is coming soon!')),
                    );
                  },
                ),
                _ProfileMenuRow(
                  icon: Icons.book_outlined,
                  title: 'Knowledge Hub',
                  subtitle: 'View device guides and manuals',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const KnowledgeHubScreen()),
                    );
                  },
                ),
                _ProfileMenuRow(
                  icon: Icons.assignment_outlined,
                  title: 'Support Requests',
                  subtitle: 'Track your service tickets',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyComplaintsScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24.0),

              _buildSectionHeader('Settings'),
              const SizedBox(height: 8.0),
              _buildMenuCard([
                _ProfileMenuRow(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: profileState.selectedLanguage,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),
                _ProfileMenuRow(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your notification preferences',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24.0),

              _buildSectionHeader('Help & Support'),
              const SizedBox(height: 8.0),
              _buildMenuCard([
                _ProfileMenuRow(
                  icon: Icons.phone_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  onTap: _callSupport,
                ),
                _ProfileMenuRow(
                  icon: Icons.edit_note_outlined,
                  title: 'Send Support Request',
                  subtitle: 'Submit a support ticket',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RaiseComplaintScreen()),
                    );
                  },
                ),
                _ProfileMenuRow(
                  icon: Icons.folder_open_outlined,
                  title: 'My Complaints',
                  subtitle: 'View and track your complaints',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyComplaintsScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24.0),

              _buildSectionHeader('App Information'),
              const SizedBox(height: 8.0),
              _buildMenuCard([
                const _ProfileMenuRow(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  showChevron: false,
                ),
                _ProfileMenuRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our terms of service',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy coming soon!')),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 28.0),

              // Red logout row at bottom
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout triggered successfully!')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: AppColors.errorRed),
                      SizedBox(width: 10.0),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.errorRed,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label, required String count}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 72.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.layers_outlined, 'My Devices'),
          _buildNavItem(1, Icons.widgets_outlined, 'Product'),
          _buildNavItem(2, Icons.home_outlined, 'Home'),
          _buildNavItem(3, Icons.book_outlined, 'Knowledge'),
          _buildNavItem(4, Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 20.0),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyDevicesScreen()),
          );
        } else if (index == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
          );
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const KnowledgeHubScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textGrey, size: 22.0),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Private Row component for menu lists inside profile screen.
class _ProfileMenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  const _ProfileMenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textGrey, size: 20.0),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12.0,
          color: AppColors.textGrey,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20.0)
          : null,
      onTap: onTap,
    );
  }
}
