import 'package:flutter/material.dart';

class TopBarCustom extends StatelessWidget implements PreferredSizeWidget {
  TopBarCustom(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Material(
            color: Colors.transparent,
            child: IconButton(icon: Icon(icon), onPressed: onTap))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
