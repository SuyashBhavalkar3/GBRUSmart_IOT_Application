import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_colors.dart';
import '../widgets/mobile_auto/primary_gradient_button.dart';
import 'knowledge_hub_data.dart';
import 'featured_guide_card.dart';
import 'category_chip_card.dart';
import 'video_thumbnail_card.dart';
import 'manual_list_item.dart';

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
    // Retrieve custom local content for this device
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
    // TODO: navigate to support request form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support request form is coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Match dashboard theme
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Knowledge Hub',
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
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24.0),

              // Featured Guides Section
              _buildSectionHeader('Featured Guides'),
              const SizedBox(height: 12.0),
              _buildFeaturedGuidesList(),
              const SizedBox(height: 28.0),

              // Learn by Category Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learn by Category',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildCategoriesGrid(),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),

              // Watch & Learn Section
              _buildSectionHeader('Watch & Learn'),
              const SizedBox(height: 12.0),
              _buildVideosList(),
              const SizedBox(height: 28.0),

              // User Manuals Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Manuals & Documentation',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildManualsList(),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),

              // Need More Help Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildHelpSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search title, topic, or heading',
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14.0),
        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildFeaturedGuidesList() {
    return SizedBox(
      height: 96.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: _content.featuredGuides.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14.0),
        itemBuilder: (context, index) {
          final guide = _content.featuredGuides[index];
          return FeaturedGuideCard(
            guide: guide,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening guide: ${guide.title}')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _content.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final item = _content.categories[index];
        return CategoryChipCard(
          item: item,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing topic: ${item.label}')),
            );
          },
        );
      },
    );
  }

  Widget _buildVideosList() {
    return SizedBox(
      height: 180.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: _content.videos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14.0),
        itemBuilder: (context, index) {
          final video = _content.videos[index];
          return VideoThumbnailCard(video: video);
        },
      ),
    );
  }

  Widget _buildManualsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _content.manuals.length,
        separatorBuilder: (context, index) => const Divider(height: 1.0, color: AppColors.borderGrey),
        itemBuilder: (context, index) {
          final manual = _content.manuals[index];
          return ManualListItem(
            manual: manual,
            onTap: () {
              // TODO: open document viewer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening document: ${manual.title}')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Need More Help?',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16.0),
        // Primary Call Support Button
        PrimaryGradientButton(
          label: 'Call Support',
          onPressed: _callSupport,
        ),
        const SizedBox(height: 12.0),
        // Secondary/Outlined Send Support Request Button
        PrimaryGradientButton(
          label: 'Send Support Request',
          backgroundColor: Colors.white,
          textColor: AppColors.primaryGreen,
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          onPressed: _sendSupportRequest,
        ),
      ],
    );
  }
}
