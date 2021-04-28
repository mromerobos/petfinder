import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  Future<void> showMyDialog(
      BuildContext context, String title, String text) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Accept'))
          ],
        );
      },
    );
  }
}
