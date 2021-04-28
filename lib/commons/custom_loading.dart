import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoading {

  late BuildContext contextTop;

  Future<void> showMyDialog(
      BuildContext context) async {
    contextTop = context;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: Container(width: 100, height: 100, child: CircularProgressIndicator()));
      },
    );
  }

  void closeAlert(BuildContext context) {
    Navigator.pop(context);//it will close last route in your navigator
  }

  void closeAlertNoContext() {
    Navigator.pop(contextTop);//it will close last route in your navigator
  }
}