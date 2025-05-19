import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4,
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Iconsax.home_2,
              activeIcon: Iconsax.home_2,
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _buildNavItem(
              icon: Iconsax.graph,
              activeIcon: Iconsax.graph,
              label: 'Statistics',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            // // Empty space for FAB
            // const SizedBox(width: 40),
            _buildNavItem(
              icon: Iconsax.calendar_1,
              activeIcon: Iconsax.calendar_1,
              label: 'Schedule',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            // _buildNavItem(
            //   icon: Iconsax.graph,
            //   activeIcon: Iconsax.graph,
            //   label: 'Statistics',
            //   isSelected: currentIndex == 3,
            //   onTap: () => onTap(3),
            // ),
            _buildNavItem(
              icon: Iconsax.user,
              activeIcon: Iconsax.user,
              label: 'Profile',
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? const Color(0xFF386BF6) : Colors.grey[400],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: isSelected ? const Color(0xFF386BF6) : Colors.grey[400],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
