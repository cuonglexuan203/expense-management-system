import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/profile/widget/categories_management_page.dart';
import 'package:expense_management_system/feature/profile/widget/currency_management_page.dart';
import 'package:expense_management_system/feature/profile/widget/language_management_page.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Track expanded state for preferences dropdown
  bool _isPreferencesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildProfileSection(context),
            const SizedBox(height: 20),
            _buildMenuItems(context, ref),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: ref.watch(currentNavIndexProvider),
        onTap: (index) =>
            BottomNavigationManager.handleNavigation(context, ref, index),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFE0EAFF),
            child: Icon(
              Iconsax.user,
              size: 50,
              color: Color(0xFF386BF6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.edit,
                  color: Color(0xFF386BF6),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Color(0xFF386BF6),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          _buildMenuItem(
            icon: Iconsax.security_safe,
            title: 'Security',
            onTap: () {
              AppSnackBar.showInfo(
                  context: context, message: 'Security feature coming soon');
            },
          ),
          _buildMenuItem(
            icon: Iconsax.notification,
            title: 'Notifications',
            onTap: () {
              AppSnackBar.showInfo(
                  context: context,
                  message: 'Notifications feature coming soon');
            },
          ),
          // Expandable preferences menu
          _buildExpandableMenuItem(
            icon: Iconsax.setting_2,
            title: 'Preferences',
            isExpanded: _isPreferencesExpanded,
            onTap: () {
              setState(() {
                _isPreferencesExpanded = !_isPreferencesExpanded;
              });
            },
            children: [
              _buildSubMenuItem(
                icon: Icons.language,
                title: 'Language',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguageManagementPage()),
                  );
                },
              ),
              _buildSubMenuItem(
                icon: Icons.currency_exchange,
                title: 'Currency',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CurrencyManagementPage()),
                  );
                },
              ),
              _buildSubMenuItem(
                icon: Iconsax.category,
                title: 'Categories',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriesManagementPage()),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          _buildMenuItem(
            icon: Iconsax.info_circle,
            title: 'Help & Support',
            onTap: () {
              AppSnackBar.showInfo(
                  context: context,
                  message: 'Help & Support feature coming soon');
            },
          ),
          _buildMenuItem(
            icon: Iconsax.document,
            title: 'Terms & Policies',
            onTap: () {
              AppSnackBar.showInfo(
                  context: context,
                  message: 'Terms & Policies feature coming soon');
            },
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(context, ref),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0EAFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF386BF6),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: isExpanded ? 5 : 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EAFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF386BF6),
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito',
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 24,
              color: Colors.grey,
            ),
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (isExpanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(left: 20, bottom: 10),
            child: Column(
              children: children,
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF386BF6),
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Nunito',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final shouldLogout = await _showLogoutConfirmation(context);
        if (shouldLogout) {
          await ref.read(authNotifierProvider.notifier).logout();
          if (context.mounted) {
            AppSnackBar.showSuccess(
                context: context, message: 'Log out successfully');
            context.go('/signIn');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.logout,
              color: Colors.red.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
