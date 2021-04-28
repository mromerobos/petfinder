import 'package:flutter/material.dart';

class UserInput extends StatelessWidget {
  UserInput(
      {Key? key,
        this.obscure = false,
        this.editMode = false,
        this.type = TextInputType.text,
        required this.hintText,
        required this.controller})
      : super(key: key);

  final TextEditingController controller;
  final bool obscure;
  final bool editMode;
  final String hintText;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        enabled: editMode,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
            border: (editMode)? OutlineInputBorder() : InputBorder.none,
            hintText: hintText),
      ),
    );
  }
}