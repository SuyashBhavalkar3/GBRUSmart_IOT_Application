import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import 'profile_provider.dart';

/// Screen 13: Language settings picker. Shows current language card and available options list.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final selectedLanguage = profileState.selectedLanguage;

    final languages = [
      {'name': 'English', 'native': 'English'},
      {'name': 'Hindi', 'native': 'हिंदी'},
      {'name': 'Marathi', 'native': 'मराठी'},
      {'name': 'Gujarati', 'native': 'ગુજરાતી'},
      {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
      {'name': 'Tamil', 'native': 'தமிழ்'},
      {'name': 'Telugu', 'native': 'తెలుగు'},
      {'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
      {'name': 'Bengali', 'native': 'বাংলা'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Language',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
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
                'Choose your preferred language',
                style: TextStyle(fontSize: 13.0, color: AppColors.textGrey),
              ),
              const SizedBox(height: 20.0),

              // "Current Language" Highlighted Card
              const Text(
                'Current Language',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withAlpha(12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedLanguage,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          languages.firstWhere((lang) => lang['name'] == selectedLanguage)['native'] ?? '',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // "Available Languages" Title
              const Text(
                'Available Languages',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8.0),

              // List of languages
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  children: languages.map((lang) {
                    final isSelected = lang['name'] == selectedLanguage;
                    return GestureDetector(
                      onTap: () {
                        // TODO: hook into actual localization
                        ref.read(profileProvider.notifier).setLanguage(lang['name']!);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language switched to ${lang['name']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F5E9).withAlpha(128) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: lang == languages.last ? Colors.transparent : AppColors.borderGrey,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  lang['native']!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryGreen : AppColors.textGrey,
                                  width: 2.0,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12.0,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24.0),

              // Footnote
              const Center(
                child: Text(
                  'The app will restart to apply the new language settings.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
