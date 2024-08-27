import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const String defaultTitle = 'EasyClicks.com';
  static const Color defaultBackgroundColor = Color.fromARGB(255, 196, 126, 46);

  final String title;
  final Widget? leadingIcon;
  final Widget? trailingWidget;
  final Color backgroundColor;

  CustomAppBar({
    this.title = defaultTitle,
    this.leadingIcon,
    this.trailingWidget,
    this.backgroundColor = defaultBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: leadingIcon ?? SizedBox(width: 40.0),
          ),
          Text(title, textAlign: TextAlign.center),
          trailingWidget ?? SizedBox(width: 40.0),
        ],
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.0);
}
