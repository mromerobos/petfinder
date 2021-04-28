import 'package:flutter/material.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Coordinates extends StatelessWidget {
  Coordinates({Key? key, required this.lat, required this.lon})
      : super(key: key);

  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => MapsLauncher.launchCoordinates(lat, lon),
      child: RichText(
        text: TextSpan(
          text: '',
          children: <TextSpan>[
            TextSpan(text: lat.toString(), style: authorText),
            TextSpan(text: ',', style: authorText),
            TextSpan(text: lon.toString(), style: authorText),
          ],
        ),
      ),
    );
  }
}
