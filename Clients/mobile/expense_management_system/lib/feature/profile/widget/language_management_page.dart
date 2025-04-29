// lib/feature/profile/widget/language_management_page.dart
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/profile/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class LanguageManagementPage extends ConsumerStatefulWidget {
  const LanguageManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageManagementPage> createState() =>
      _LanguageManagementPageState();
}

class _LanguageManagementPageState
    extends ConsumerState<LanguageManagementPage> {
  String? _selectedLanguage;
  bool _isChangingLanguage = false;

  @override
  void initState() {
    super.initState();
    // Store initial language for comparison
    _selectedLanguage = ref.read(languageProvider);
  }

  final availableLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸', 'localName': 'English'},
    {
      'code': 'vi',
      'name': 'Vietnamese',
      'flag': '🇻🇳',
      'localName': 'Tiếng Việt'
    },
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷', 'localName': 'Français'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸', 'localName': 'Español'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Only show save button if language changed and not currently saving
          if (_selectedLanguage != currentLanguage && !_isChangingLanguage)
            TextButton(
              onPressed: _applyLanguageChange,
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF386BF6),
                ),
              ),
            ),
        ],
      ),
      body: _isChangingLanguage
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Changing language...',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F9FF),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0EAFF),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.info_circle,
                        color: Color(0xFF386BF6),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Changing the language will update all text in the app. Currency and other preferences will remain the same.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Language list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: availableLanguages.map((language) {
                      final isSelected = _selectedLanguage == language['code'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE0EAFF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = language['code'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Flag container
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F9FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      language['flag']!,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Language details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          language['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          language['localName']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection indicator
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF386BF6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _applyLanguageChange() async {
    if (_selectedLanguage != ref.read(languageProvider)) {
      setState(() {
        _isChangingLanguage = true;
      });

      try {
        // Update language in provider
        await ref
            .read(languageProvider.notifier)
            .setLanguage(_selectedLanguage!);

        // Force rebuild of dependent widgets
        ref.invalidate(languageProvider);

        if (mounted) {
          AppSnackBar.showSuccess(
            context: context,
            message: 'Language changed successfully',
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.showError(
            context: context,
            message: 'Failed to change language: $e',
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isChangingLanguage = false;
          });
        }
      }
    }
  }
}
