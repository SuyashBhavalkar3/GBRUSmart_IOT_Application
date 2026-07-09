import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../screens/home_dashboard_screen.dart';
import '../../screens/my_devices/my_devices_screen.dart';
import 'knowledge_hub_detail_screen.dart';
import '../My_Profile/profile_screen.dart';

/// Screen 9: Main Knowledge Hub catalog listing device categories.
class KnowledgeHubScreen extends StatefulWidget {
  const KnowledgeHubScreen({super.key});

  @override
  State<KnowledgeHubScreen> createState() => _KnowledgeHubScreenState();
}

class _KnowledgeHubScreenState extends State<KnowledgeHubScreen> {
  final int _currentIndex = 3; // Index 3 is 'Knowledge'

  final List<Map<String, String>> _categories = [
    {
      'title': 'Motor Mitra Smart',
      'subtitle': '2 Devices',
      'imagePath': 'assets/home_dashboard_assets/1ac4b5b1fed93ebf8315b1b13f434db065bf1a22.png',
    },
    {
      'title': 'Motor Mitra Secure+',
      'subtitle': '2 Devices',
      'imagePath': 'assets/home_dashboard_assets/1ac4b5b1fed93ebf8315b1b13f434db065bf1a22.png',
    },
    {
      'title': 'Solar Camera',
      'subtitle': '2 Devices',
      'imagePath': 'assets/home_dashboard_assets/778b9f3c166b965b24088e4596de5e2232093dc2.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match light layout background
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
              // TODO: wire search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search catalog is coming soon!')),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20.0),
          itemCount: _categories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(category);
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoryCard(Map<String, String> category) {
    final title = category['title']!;
    final subtitle = category['subtitle']!;
    final imagePath = category['imagePath']!;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KnowledgeHubDetailScreen(deviceName: title),
          ),
        );
      },
      child: Container(
        height: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textDark.withAlpha(178),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // Small circular go icon
                    Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryGreen,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Right image decoration (reused asset)
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        ),
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
