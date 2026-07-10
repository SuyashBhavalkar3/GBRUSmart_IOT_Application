import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../screens/home_dashboard_screen.dart';
import '../../screens/my_devices/my_devices_screen.dart';
import '../My_Profile/profile_screen.dart';

/// Screen 9: Redesigned Knowledge Hub screen matching the user's mockup.
class KnowledgeHubScreen extends StatefulWidget {
  const KnowledgeHubScreen({super.key});

  @override
  State<KnowledgeHubScreen> createState() => _KnowledgeHubScreenState();
}

class _KnowledgeHubScreenState extends State<KnowledgeHubScreen> {
  final int _currentIndex = 3; // Index 3 is 'Knowledge'

  // Categories grid content
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Device Usage',
      'subtitle': 'Learn how to use all features',
      'count': '12 articles',
      'icon': Icons.phone_android_outlined,
      'color': const Color(0xFF2196F3),
    },
    {
      'title': 'Troubleshooting',
      'subtitle': 'Fix common problems',
      'count': '8 articles',
      'icon': Icons.build_circle_outlined,
      'color': const Color(0xFF4CAF50),
    },
    {
      'title': 'Irrigation Tips',
      'subtitle': 'Best practices for farming',
      'count': '10 articles',
      'icon': Icons.water_drop_outlined,
      'color': const Color(0xFF03A9F4),
    },
    {
      'title': 'Alerts Explained',
      'subtitle': 'Understand device alerts',
      'count': '6 articles',
      'icon': Icons.notifications_active_outlined,
      'color': const Color(0xFFFF9800),
    },
  ];

  // Featured Guides content
  final List<Map<String, dynamic>> _featuredGuides = [
    {
      'title': 'How to Use Auto Mode',
      'subtitle': 'Control your motor automatically using rules/timers.',
      'icon': Icons.auto_mode_outlined,
    },
    {
      'title': 'Setting Up Rules',
      'subtitle': 'Create daily rules for automatic motor control.',
      'icon': Icons.schedule_outlined,
    },
  ];

  // Videos content
  final List<Map<String, String>> _videos = [
    {
      'title': 'How to Install Mobile Auto',
      'duration': '1:30',
    },
    {
      'title': 'How to Set Timers & Rules',
      'duration': '2:15',
    },
  ];

  // User Manuals and Documents
  final List<Map<String, dynamic>> _documents = [
    {
      'title': 'Mobile Auto User Manual',
      'subtitle': 'Complete installation, setup, and troubleshooting guide.',
      'badge': 'PDF',
      'size': '2.4 MB • 24 pages',
      'color': const Color(0xFFF44336), // Red
    },
    {
      'title': 'Quick Start Guide',
      'subtitle': 'Get started in 5 simple steps.',
      'badge': 'PDF',
      'size': '850 KB • 6 pages',
      'color': const Color(0xFF2196F3), // Blue
    },
    {
      'title': 'Troubleshooting Guide',
      'subtitle': 'Solutions for common errors.',
      'badge': 'PDF',
      'size': '1.2 MB • 12 pages',
      'color': const Color(0xFFFF9800), // Orange
    },
    {
      'title': 'Installation & Wiring Diagram',
      'subtitle': 'Flowchart for electrical wiring.',
      'badge': 'PDF',
      'size': '3.2 MB • 8 pages',
      'color': const Color(0xFF9C27B0), // Purple
    },
    {
      'title': 'Safety & Maintenance',
      'subtitle': 'Safety warnings and tips.',
      'badge': 'PDF',
      'size': '1.5 MB • 10 pages',
      'color': const Color(0xFFFFB300), // Yellow/amber
    },
    {
      'title': 'Warranty & Support Info',
      'subtitle': 'Terms, coverage & support contacts.',
      'badge': 'PDF',
      'size': '500 KB • 4 pages',
      'color': const Color(0xFF4CAF50), // Green
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Soft mint green background
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 18.0, color: AppColors.textDark),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
                );
              },
            ),
          ),
        ),
        title: const Text(
          'Knowledge Hub',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textDark),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search catalog is coming soon!')),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search help topics or device tips...',
                    hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13.0),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20.0),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.borderGrey),
                    ),
                  ),
                ),
              ),

              // Featured Guides Section
              _buildSectionHeader('Featured Guides'),
              _buildFeaturedGuides(),

              // Learn by Category Section
              _buildSectionHeader('Learn by Category'),
              _buildCategoriesGrid(),

              // Watch & Learn Section
              _buildSectionHeader('Watch & Learn'),
              _buildVideosList(),

              // User Manuals & Documentation Section
              _buildSectionHeader('User Manuals & Documentation'),
              _buildDocumentsList(),

              // Need More Help? Card
              _buildNeedMoreHelpCard(),
              
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildFeaturedGuides() {
    return SizedBox(
      height: 140.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _featuredGuides.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12.0),
        itemBuilder: (context, index) {
          final guide = _featuredGuides[index];
          return Container(
            width: 175.0,
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6F22), // Deep green guide card background matching image
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    guide['icon'],
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
                const Spacer(),
                Text(
                  guide['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  guide['subtitle'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 10.0,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 1.35,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top-left icon in soft blue-tinted background matching layout
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF3FC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat['icon'],
                    color: const Color(0xFF2196F3),
                    size: 18.0,
                  ),
                ),
                const Spacer(),
                Text(
                  cat['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  cat['subtitle'],
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 9.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6.0),
                Text(
                  cat['count'],
                  style: const TextStyle(
                    color: Color(0xFF00A859), // Theme green matching screenshot
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosList() {
    return SizedBox(
      height: 160.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _videos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12.0),
        itemBuilder: (context, index) {
          final video = _videos[index];
          return SizedBox(
            width: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video thumbnail
                Stack(
                  children: [
                    Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4), // Light blue play card matching mockup
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.0,
                      right: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          video['duration']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  video['title']!,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocumentsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _documents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12.0),
      itemBuilder: (context, index) {
        final doc = _documents[index];
        final docColor = doc['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
          ),
          child: Row(
            children: [
              // PDF color-coded soft background circle
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: docColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.picture_as_pdf_outlined,
                  color: docColor,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textGrey,
                          size: 16.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              // Action green download circular button
              Container(
                width: 32.0,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E6F22), // Matching the dark green shade
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNeedMoreHelpCard() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need More Help?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Call Support green action button
          SizedBox(
            width: double.infinity,
            height: 46.0,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A859), // Solid green Support
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0.0,
              ),
              onPressed: () {},
              icon: const Icon(Icons.phone, size: 18.0),
              label: const Text(
                'Call Support',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          
          // Email Support white action button
          SizedBox(
            width: double.infinity,
            height: 46.0,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textDark,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.description_outlined, size: 18.0),
              label: const Text(
                'Email Support Request',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ),
          ),
        ],
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
        } else if (index == 4) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
