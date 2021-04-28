import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  InputForm(
      {Key? key,
      this.obscure = false,
      required this.hintText,
      required this.labelText,
      required this.controller})
      : super(key: key);

  final TextEditingController controller;
  final bool obscure;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }
}
