import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/announcement.dart';

class AnnouncementMin extends StatelessWidget {
  AnnouncementMin(
      {Key? key,
        required this.announcement, required this.onTap})
      : super(key: key);

  final Announcement announcement;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.green.shade700.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(announcement.id),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  announcement.images.first,
                  fit: BoxFit.contain,
                  height: 100,
                  width: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(announcement.title, style: sectionText),
                  Text(DateFormat('HH:mm dd/MM/yyyy').format(announcement.date), style: normalText),
                  Text(announcement.author_name, style: normalText)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}