import 'package:flutter/material.dart';
import 'package:expense_management_system/gen/colors.gen.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double height;
  
  const CustomHeader({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.actions,
    this.backgroundColor = ColorName.blue,
    this.height = kToolbarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: Colors.white),
              onPressed: onLeadingPressed,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
          color: Colors.white,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}