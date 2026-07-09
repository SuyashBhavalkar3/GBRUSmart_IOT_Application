import 'package:flutter/material.dart';

/// Content model for Featured Guides.
class FeaturedGuide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const FeaturedGuide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Content model for Categories.
class CategoryItem {
  final String label;
  final IconData icon;
  final Color iconColor;

  const CategoryItem({
    required this.label,
    required this.icon,
    required this.iconColor,
  });
}

/// Content model for Video tutorials.
class VideoTutorial {
  final String youtubeVideoId;
  final String title;
  final String duration;

  const VideoTutorial({
    required this.youtubeVideoId,
    required this.title,
    required this.duration,
  });

  /// Computed thumbnail URL from YouTube's public CDN pattern.
  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg';
}

/// Content model for User Manuals.
class UserManual {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const UserManual({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Consolidated Content Object returned per device type.
class KnowledgeHubContent {
  final String deviceName;
  final List<FeaturedGuide> featuredGuides;
  final List<CategoryItem> categories;
  final List<VideoTutorial> videos;
  final List<UserManual> manuals;

  const KnowledgeHubContent({
    required this.deviceName,
    required this.featuredGuides,
    required this.categories,
    required this.videos,
    required this.manuals,
  });
}

/// Content source manager.
class KnowledgeHubData {
  /// Named constants for placeholder YouTube video IDs (swappable later).
  static const String videoIdHowToInstall = 'dQw4w9WgXcQ';
  static const String videoIdSettingUpGeo = 'jNQXAC9IVRw';

  static KnowledgeHubContent getContentForDevice(String deviceName) {
    switch (deviceName) {
      case 'Motor Mitra Secure+':
        return KnowledgeHubContent(
          deviceName: deviceName,
          featuredGuides: [
            const FeaturedGuide(
              title: 'Enabling Anti-Theft Lock',
              subtitle: 'Secure your vehicle with one tap',
              icon: Icons.security_rounded,
              iconColor: Color(0xFF1E88E5),
              iconBgColor: Color(0xFFE3F2FD),
            ),
            const FeaturedGuide(
              title: 'Vehicle Geo-Fencing',
              subtitle: 'Monitor device boundaries live',
              icon: Icons.map_outlined,
              iconColor: Color(0xFFFFB300),
              iconBgColor: Color(0xFFFFF8E1),
            ),
          ],
          categories: [
            const CategoryItem(label: 'Anti-Theft', icon: Icons.lock_outline, iconColor: Color(0xFFE53935)),
            const CategoryItem(label: 'GPS History', icon: Icons.history_toggle_off, iconColor: Color(0xFF1FAA59)),
            const CategoryItem(label: 'Battery Health', icon: Icons.battery_charging_full, iconColor: Color(0xFF1E88E5)),
            const CategoryItem(label: 'Alerts Config', icon: Icons.notifications_none_rounded, iconColor: Color(0xFF8E24AA)),
          ],
          videos: [
            const VideoTutorial(
              youtubeVideoId: videoIdHowToInstall,
              title: 'Setting Anti-Theft Lock',
              duration: '3 mins video',
            ),
            const VideoTutorial(
              youtubeVideoId: videoIdSettingUpGeo,
              title: 'Reading GPS History Logs',
              duration: '4 mins video',
            ),
          ],
          manuals: _getGenericManuals('Secure+'),
        );
      case 'Solar Camera':
        return KnowledgeHubContent(
          deviceName: deviceName,
          featuredGuides: [
            const FeaturedGuide(
              title: 'Motion Detection setup',
              subtitle: 'Reduce false alerts easily',
              icon: Icons.motion_photos_on_rounded,
              iconColor: Color(0xFFD81B60),
              iconBgColor: Color(0xFFFCE4EC),
            ),
            const FeaturedGuide(
              title: 'Solar Panel Alignment',
              subtitle: 'Optimize charging efficiency',
              icon: Icons.wb_sunny_outlined,
              iconColor: Color(0xFFFFB300),
              iconBgColor: Color(0xFFFFF8E1),
            ),
          ],
          categories: [
            const CategoryItem(label: 'Solar Charge', icon: Icons.solar_power_outlined, iconColor: Color(0xFFFFB300)),
            const CategoryItem(label: 'Motion Alerts', icon: Icons.running_with_errors, iconColor: Color(0xFFD81B60)),
            const CategoryItem(label: 'Live Stream', icon: Icons.videocam_outlined, iconColor: Color(0xFF1FAA59)),
            const CategoryItem(label: 'Cloud Logs', icon: Icons.cloud_done_outlined, iconColor: Color(0xFF1E88E5)),
          ],
          videos: [
            const VideoTutorial(
              youtubeVideoId: videoIdHowToInstall,
              title: 'Solar Panel Alignment Guide',
              duration: '5 mins video',
            ),
            const VideoTutorial(
              youtubeVideoId: videoIdSettingUpGeo,
              title: 'Configuring Motion Detection',
              duration: '3 mins video',
            ),
          ],
          manuals: _getGenericManuals('Solar Camera'),
        );
      case 'Motor Mitra Smart':
      default:
        return KnowledgeHubContent(
          deviceName: deviceName,
          featuredGuides: [
            const FeaturedGuide(
              title: 'How to Use Auto Mode',
              subtitle: 'Configure automated irrigation timers',
              icon: Icons.offline_bolt_outlined,
              iconColor: Color(0xFF1FAA59),
              iconBgColor: Color(0xFFE8F5E9),
            ),
            const FeaturedGuide(
              title: 'Setting Up Geo Fence',
              subtitle: 'Track installation area boundaries',
              icon: Icons.location_on_outlined,
              iconColor: Color(0xFF1E88E5),
              iconBgColor: Color(0xFFE3F2FD),
            ),
          ],
          categories: [
            const CategoryItem(label: 'Electric Usage', icon: Icons.electric_bolt_outlined, iconColor: Color(0xFFFFB300)),
            const CategoryItem(label: 'Troubleshooting', icon: Icons.build_outlined, iconColor: Color(0xFFE53935)),
            const CategoryItem(label: 'Ignition Tips', icon: Icons.wb_incandescent_outlined, iconColor: Color(0xFF1FAA59)),
            const CategoryItem(label: 'Alerts Explained', icon: Icons.info_outline_rounded, iconColor: Color(0xFF8E24AA)),
          ],
          videos: [
            const VideoTutorial(
              youtubeVideoId: videoIdHowToInstall,
              title: 'How to Install Auto Mode',
              duration: '4 mins video',
            ),
            const VideoTutorial(
              youtubeVideoId: videoIdSettingUpGeo,
              title: 'Setting Up Geo Fence',
              duration: '5 mins video',
            ),
          ],
          manuals: _getGenericManuals('Smart Auto'),
        );
    }
  }

  static List<UserManual> _getGenericManuals(String suffix) {
    return [
      UserManual(
        title: '$suffix User Manual',
        subtitle: 'Version 3.4 · Updated Jan 2026',
        icon: Icons.menu_book_rounded,
        iconColor: const Color(0xFF1FAA59),
      ),
      const UserManual(
        title: 'Quick Start Guide',
        subtitle: 'Get started in 5 simple steps',
        icon: Icons.electric_bolt_outlined,
        iconColor: Color(0xFF1E88E5),
      ),
      const UserManual(
        title: 'Troubleshooting Guide',
        subtitle: 'Fix common connectivity issues',
        icon: Icons.construction_outlined,
        iconColor: Color(0xFFE53935),
      ),
      const UserManual(
        title: 'Installation & Wiring Diagram',
        subtitle: 'Step-by-step setup visuals',
        icon: Icons.map_outlined,
        iconColor: Color(0xFF8E24AA),
      ),
      const UserManual(
        title: 'Safety & Maintenance',
        subtitle: 'Best practices for long-term use',
        icon: Icons.gpp_good_outlined,
        iconColor: Color(0xFFFFB300),
      ),
      const UserManual(
        title: 'Warranty & Support Info',
        subtitle: 'Terms, coverage & how to claim',
        icon: Icons.badge_outlined,
        iconColor: Color(0xFF78909C),
      ),
    ];
  }
}
