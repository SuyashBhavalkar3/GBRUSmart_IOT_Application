import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_colors.dart';
import 'knowledge_hub_data.dart';
import '../screens/home_dashboard_screen.dart';
import '../../screens/my_devices/my_devices_screen.dart';
import '../My_Profile/profile_screen.dart';

/// Screen 10: Detail screen displaying knowledge bases specific to the selected device category.
class KnowledgeHubDetailScreen extends StatefulWidget {
  final String deviceName;

  const KnowledgeHubDetailScreen({
    super.key,
    required this.deviceName,
  });

  @override
  State<KnowledgeHubDetailScreen> createState() => _KnowledgeHubDetailScreenState();
}

class _KnowledgeHubDetailScreenState extends State<KnowledgeHubDetailScreen> {
  final _searchController = TextEditingController();
  late KnowledgeHubContent _content;

  @override
  void initState() {
    super.initState();
    // Retrieve content dynamically based on the tapped category device name
    _content = KnowledgeHubData.getContentForDevice(widget.deviceName);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _sendSupportRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support request form is coming soon!')),
    );
  }

  String _getCategoryCount(String label) {
    switch (label) {
      case 'Device Usage':
      case 'Anti-Theft':
      case 'Solar Charge':
        return '12 articles';
      case 'Troubleshooting':
      case 'GPS History':
      case 'Motion Alerts':
        return '8 articles';
      case 'Irrigation Tips':
      case 'Battery Health':
      case 'Live Stream':
        return '10 articles';
      case 'Alerts Explained':
      case 'Alerts Config':
      case 'Cloud Logs':
        return '6 articles';
      default:
        return '8 articles';
    }
  }

  String _getCategorySubtitle(String label) {
    switch (label) {
      case 'Device Usage':
        return 'Learn how to use all features';
      case 'Troubleshooting':
        return 'Fix common problems';
      case 'Irrigation Tips':
        return 'Best practices for farming';
      case 'Alerts Explained':
        return 'Understand device alerts';
      case 'Anti-Theft':
        return 'Secure your vehicle';
      case 'GPS History':
        return 'View travel paths';
      case 'Battery Health':
        return 'Monitor charge levels';
      case 'Alerts Config':
        return 'Manage notification rules';
      case 'Solar Charge':
        return 'Optimize solar intake';
      case 'Motion Alerts':
        return 'Configure trigger sensitivity';
      case 'Live Stream':
        return 'Watch live camera feed';
      case 'Cloud Logs':
        return 'View remote recordings';
      default:
        return 'Guides and help documents';
    }
  }

  String _getDocumentSizeAndPages(int index) {
    final sizes = [
      '2.4 MB • 24 pages',
      '850 KB • 6 pages',
      '1.2 MB • 12 pages',
      '3.2 MB • 8 pages',
      '1.5 MB • 10 pages',
      '500 KB • 4 pages'
    ];
    if (index >= 0 && index < sizes.length) {
      return sizes[index];
    }
    return '1.0 MB • 10 pages';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match light layout background
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
              onPressed: () => Navigator.of(context).pop(),
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
            onPressed: () {},
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
                  controller: _searchController,
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
        itemCount: _content.featuredGuides.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12.0),
        itemBuilder: (context, index) {
          final guide = _content.featuredGuides[index];
          return Container(
            width: 175.0,
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6F22), // Deep green card background
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    guide.icon,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
                const Spacer(),
                Text(
                  guide.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  guide.subtitle,
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
        itemCount: _content.categories.length,
        itemBuilder: (context, index) {
          final cat = _content.categories[index];
          final countText = _getCategoryCount(cat.label);
          final subtitleText = _getCategorySubtitle(cat.label);
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
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBF3FC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat.icon,
                    color: const Color(0xFF2196F3),
                    size: 18.0,
                  ),
                ),
                const Spacer(),
                Text(
                  cat.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitleText,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 9.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6.0),
                Text(
                  countText,
                  style: const TextStyle(
                    color: Color(0xFF00A859),
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
        itemCount: _content.videos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12.0),
        itemBuilder: (context, index) {
          final video = _content.videos[index];
          return SizedBox(
            width: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 110.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4), // Play card background
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
                          video.duration,
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
                  video.title,
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
      itemCount: _content.manuals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12.0),
      itemBuilder: (context, index) {
        final manual = _content.manuals[index];
        final docColor = manual.iconColor;
        final docSizeText = _getDocumentSizeAndPages(index);
        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
          ),
          child: Row(
            children: [
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
                    Text(
                      manual.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      manual.subtitle,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: docColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            'PDF',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 8.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          docSizeText,
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                width: 32.0,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E6F22), // Deep green download button
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
          SizedBox(
            width: double.infinity,
            height: 46.0,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A859), // Theme green call support
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0.0,
              ),
              onPressed: _callSupport,
              icon: const Icon(Icons.phone, size: 18.0),
              label: const Text(
                'Call Support',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
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
              onPressed: _sendSupportRequest,
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
    const int currentIndex = 3; // Index 3 is 'Knowledge'
    final isSelected = currentIndex == index;

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