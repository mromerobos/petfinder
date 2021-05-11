import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/comment.dart';
import 'package:petfinder/widgets/coordinates.dart';

class CommentView extends StatelessWidget {
  CommentView({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.green.shade700.withOpacity(0.2),
          /*borderRadius: BorderRadius.circular(5)*/),
      child: Column(
        children: [
          (comment.images.length == 0)
              ? Container()
              : CarouselSlider(
                  options: CarouselOptions(),
                  items: comment.images
                      .map((item) => Container(
                            height: 300,
                            width: 300,
                            child: Image.network(
                              item,
                              fit: BoxFit.contain,
                            ),
                          ))
                      .toList(),
                ),
          Row(
            children: [
              Text('Seen at: ', style: sectionText),
              Expanded(
                child: Text(
                  DateFormat('HH:mm dd/MM/yyyy').format(comment.date),
                  style: normalText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Seen in: ',
                style: sectionText,
              ),
              Coordinates(lat: comment.latitude, lon: comment.longitude),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Description:',
                  style: sectionText,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(5)),
            child: Text(comment.description, style: normalText),
          )
        ],
      ),
    );
  }
}
