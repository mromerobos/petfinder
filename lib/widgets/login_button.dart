import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  LoginButton(
      {Key? key,
      this.imageSrc = "",
      required this.text,
      required this.color,
      required this.onTap})
      : super(key: key);

  final VoidCallback? onTap;
  final String imageSrc;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: ElevatedButton(
          onPressed:  onTap,
          style: ElevatedButton.styleFrom(primary: color),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (imageSrc.length > 0)
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    width: 30,
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(imageSrc),
                    )),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
