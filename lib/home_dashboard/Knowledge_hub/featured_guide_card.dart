import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'knowledge_hub_data.dart';

/// Card showing details of a featured guide.
class FeaturedGuideCard extends StatelessWidget {
  final FeaturedGuide guide;
  final VoidCallback onTap;

  const FeaturedGuideCard({
    super.key,
    required this.guide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.0,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: guide.iconBgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                guide.icon,
                color: guide.iconColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    guide.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    guide.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textGrey,
                      height: 1.3,
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
