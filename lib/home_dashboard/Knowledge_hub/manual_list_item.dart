import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'knowledge_hub_data.dart';

/// Row component displaying manual documents.
class ManualListItem extends StatelessWidget {
  final UserManual manual;
  final VoidCallback onTap;

  const ManualListItem({
    super.key,
    required this.manual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: manual.iconColor.withAlpha(25),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          manual.icon,
          color: manual.iconColor,
          size: 22.0,
        ),
      ),
      title: Text(
        manual.title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        manual.subtitle,
        style: const TextStyle(
          fontSize: 12.0,
          color: AppColors.textGrey,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textGrey,
        size: 20.0,
      ),
      onTap: onTap,
    );
  }
}
