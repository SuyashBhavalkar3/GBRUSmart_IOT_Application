import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_colors.dart';
import 'knowledge_hub_data.dart';

/// Card showing a video tutorial thumbnail with play button overlay.
/// Launches the video externally in browser/app using url_launcher.
class VideoThumbnailCard extends StatelessWidget {
  final VideoTutorial video;

  const VideoThumbnailCard({
    super.key,
    required this.video,
  });

  Future<void> _launchVideo(BuildContext context) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=${video.youtubeVideoId}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open video URL: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchVideo(context),
      child: Container(
        width: 170.0,
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
            // Video Thumbnail image with play overlay
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    width: 170.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 170.0,
                        height: 100.0,
                        color: AppColors.borderGrey,
                        child: const Icon(Icons.broken_image_outlined, color: AppColors.textGrey),
                      );
                    },
                  ),
                  // Dark shadow overlay for high visibility
                  Container(
                    width: 170.0,
                    height: 100.0,
                    color: Colors.black.withAlpha(40),
                  ),
                  // Centered play button icon matching screenshot
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primaryGreen,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Metadata
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    video.duration,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
