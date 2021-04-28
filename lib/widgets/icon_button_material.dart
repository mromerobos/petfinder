import 'package:flutter/material.dart';

class IconButtonWithMaterial extends StatelessWidget {
  IconButtonWithMaterial(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }
}
