import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;
  final List<Widget> actions;
  final TextStyle textStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.actions,
    required this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      titleTextStyle: textStyle,
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
