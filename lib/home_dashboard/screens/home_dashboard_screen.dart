import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'mobile_auto/select_device_to_activate_screen.dart';
import '../../screens/my_devices/my_devices_screen.dart';
import '../Knowledge_hub/knowledge_hub_screen.dart';
import '../My_Profile/profile_screen.dart';

/// Screen 1: The Main Dashboard page matching the provided mock design.
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 2; // Default to 'Home' (index 2)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Light soft mint background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(),
              const SizedBox(height: 16.0),
              _buildSearchBar(),
              const SizedBox(height: 20.0),
              _buildWeatherCard(),
              const SizedBox(height: 24.0),
              const Text(
                'Our Devices',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              const Text(
                'You can add devices listed below and make device to pair-up quickly.',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textGrey,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24.0),
              _buildDeviceCardsList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Ankita',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        // Notification bell with red badge inside rounded white box
        Stack(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.textDark,
                size: 24.0,
              ),
            ),
            Positioned(
              top: 12.0,
              right: 12.0,
              child: Container(
                width: 7.0,
                height: 7.0,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          SizedBox(width: 14.0),
          Icon(Icons.search, color: AppColors.textGrey, size: 20.0),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              'Search Here',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14.0,
              ),
            ),
          ),
          Icon(Icons.mic_none_outlined, color: AppColors.textGrey, size: 20.0),
          SizedBox(width: 14.0),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7DC9FC), Color(0xFF5BA2F6)], // Sky blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5BA2F6).withAlpha(64),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top weather row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom illustration representing sun & cloud
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Sunny sun
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFB300),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
                  // Overlapping white clouds
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: Row(
                      children: [
                        Container(
                          width: 24.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-8.0, 4.0),
                          child: Container(
                            width: 20.0,
                            height: 14.0,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(230),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '24°c',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 12.0),
                      SizedBox(width: 4.0),
                      Text(
                        'Bengaluru, Karnataka',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Bottom row of weather parameters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherStat(Icons.opacity, 'Humidity', '65%'),
              _buildWeatherStat(Icons.arrow_forward_outlined, 'Wind', '12 km/h'),
              _buildWeatherStat(Icons.wb_sunny_outlined, 'UV Index', 'High'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withAlpha(200), size: 16.0),
        const SizedBox(width: 6.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9.0,
                color: Colors.white.withAlpha(180),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceCardsList() {
    return Column(
      children: [
        _buildDeviceCard(
          title: 'Motor Mitra Smart',
          subtitle: '2 Devices',
          imagePath: 'assets/home_dashboard_assets/1ac4b5b1fed93ebf8315b1b13f434db065bf1a22.png',
          onTap: () {
            // Phase 1: always navigate to SelectDeviceToActivateScreen.
            // Future: query backend to check pre-registered devices and route to
            // AddMobileAutoEmptyScreen when no pending activations exist.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SelectDeviceToActivateScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildDeviceCard(
          title: 'Motor Mitra Secure+',
          subtitle: '2 Devices',
          imagePath: 'assets/home_dashboard_assets/1ac4b5b1fed93ebf8315b1b13f434db065bf1a22.png',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Motor Mitra Secure+ onboarding coming soon!'),
                backgroundColor: AppColors.textGrey,
              ),
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildDeviceCard(
          title: 'Solar Camera',
          subtitle: '2 Devices',
          imagePath: 'assets/home_dashboard_assets/778b9f3c166b965b24088e4596de5e2232093dc2.png',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solar Camera onboarding coming soon!'),
                backgroundColor: AppColors.textGrey,
              ),
            );
          },
          isCamera: true,
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
    bool isCamera = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Gradient Card Container
          Container(
            width: double.infinity,
            height: 110.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC7F5D9), Color(0xFF86E8A6)], // Soft green gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF86E8A6).withAlpha(51),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textDark,
                        size: 18.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned overlapping device image on the right
          Positioned(
            right: 12.0,
            bottom: -10.0,
            child: SizedBox(
              width: isCamera ? 120.0 : 100.0,
              height: isCamera ? 135.0 : 125.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
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
          color: const Color(0xFFE8F5E9), // Light green capsule background
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
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const KnowledgeHubScreen()),
          );
        } else if (index == 4) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
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
