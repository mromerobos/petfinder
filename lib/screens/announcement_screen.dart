import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petfinder/commons/arguments.dart';
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/models/comment.dart';
import 'package:petfinder/models/follow.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/screens/user_screen.dart';
import 'package:petfinder/services/comment_service.dart';
import 'package:petfinder/services/follow_service.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/comment_view.dart';
import 'package:petfinder/widgets/coordinates.dart';
import 'package:petfinder/widgets/icon_button_material.dart';
import 'package:petfinder/widgets/top_bar_custom.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


import 'add_screen.dart';
import 'other_user_screen.dart';

class AnnouncementScreen extends StatefulWidget {
  static const String id = 'announcement_screen';

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  CommentService commentService = CommentService();
  UserService userService = UserService();
  FollowService followService = FollowService();

  late Announcement announcement;
  bool collapsed = false;

  Follow? followed;

  List<Comment> commentsList = [];

  List<Widget> comments = <Widget>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getCommentsAndFollows());
  }

  @override
  Widget build(BuildContext context) {
    final AnnouncementScreenArguments args = ModalRoute.of(context)!
        .settings
        .arguments as AnnouncementScreenArguments;
    announcement = args.announcement;
    comments = commentsList.map((e) => CommentView(comment: e)).toList();
    return Scaffold(
      appBar: TopBarCustom(
        icon: Icons.person,
        title: 'Announcement',
        onTap: goToUserProfile,
      ),
      body: Column(
        children: [
          (collapsed) ? topAnnouncementView() : Container(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (collapsed) ? Container() : announcementView(),
                  SizedBox(height: 10),
                  Column(
                    children: comments,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String authorText() {
    String text = '';
    if (announcement.author_show)
      text = announcement.author_name +
          ' (' +
          announcement.author_tel.toString() +
          ')';
    else
      text = announcement.author_name;
    return text;
  }

  Widget topAnnouncementView() {
    return Container(
      color: Colors.blueAccent.shade100,
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () =>
                      goToOtherUserProfile(announcement.author_email),
                  child: Text(announcement.author_name,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 18))),
              Expanded(child: Container()),
              IconButtonWithMaterial(
                  icon: Icons.share, onPressed: () => shareInfo),
              IconButtonWithMaterial(
                  icon: Icons.add_comment_outlined,
                  onPressed: () => addComment()),
              IconButtonWithMaterial(
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () => setState(() => collapsed = false)),
            ],
          ),
          Container(
            color: Colors.blueAccent,
            height: 4,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  Widget announcementView() {
    return Container(
      color: Colors.blueAccent.shade100,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Text(
            announcement.title,
            style: sectionText,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CarouselSlider(
              options: CarouselOptions(),
              items: announcement.images
                  .map((item) => Container(
                        child: Center(
                            child: Image.network(item,
                                fit: BoxFit.contain, width: 350)),
                      ))
                  .toList(),
            ),
          ),
          Row(
            children: [
              Text('Seen at: ', style: sectionText),
              Expanded(
                child: Text(
                  DateFormat('HH:mm dd/MM/yyyy').format(announcement.date),
                  style: normalText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Seen on: ', style: sectionText,),
              Coordinates(
                  lat: announcement.latitude, lon: announcement.longitude),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5)),
            child: Text(announcement.description, style: normalText),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () =>
                      goToOtherUserProfile(announcement.author_email),
                  child: Text(authorText(),
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 18))),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container()),
              IconButtonWithMaterial(
                  icon: (followed != null)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  onPressed: () => followAction()),
              IconButtonWithMaterial(
                  icon: Icons.share, onPressed: () => shareInfo()),
              IconButtonWithMaterial(
                  icon: Icons.add_comment_outlined,
                  onPressed: () => addComment()),
              IconButtonWithMaterial(
                  icon: Icons.keyboard_arrow_up,
                  onPressed: () => setState(() => collapsed = true)),
            ],
          ),
          Container(
            color: Colors.blueAccent,
            height: 4,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  Future<void> getCommentsAndFollows() async {
    commentsList = await commentService.getCommentsForAnnouncement(announcement.id);
    Follow? follow = await followService.isFollowAnnounce(
        userService.userCustom.email, announcement.id);
    if (follow != null) {
      followed = follow;
    }
    setState(() {});
  }

  addComment() async {
    final dynamic? id = await Navigator.pushNamed(context, AddScreen.id,
        arguments: AddScreenArguments(false, announcement.id));
    if (id != null) {
      Comment? comment = await commentService.getComment(id);
      if (comment != null) {
        setState(() {
          commentsList.insert(0, comment);
        });
      } else {
        CustomAlert().showMyDialog(context, 'Comment created',
            'Some error ocurred when getting comment data');
      }
    }
  }

  followAction() {
    if (followed != null)
      unFollowAdd();
    else
      followAdd();
  }

  unFollowAdd() async {
    bool follow = await followService.unFollowAnnouncement(followed!.id);
    if (follow) {
      setState(() {
        followed = null;
      });
    }
  }

  followAdd() async {
    Follow? follow = await followService.followAnnouncement(
        userService.userCustom.email, announcement.id);
    if (follow != null) {
      setState(() {
        followed = follow;
      });
    }
  }

  shareInfo() async {
    //await Share.shareFiles(await _fileFromImageUrl(), text: announcement.description, subject: announcement.title);
    //await Share.shareFiles( await _filePathFromUrl(), text: announcement.description, subject: announcement.title);
    downloadFileExampleAndShare();
  }

  goToOtherUserProfile(String email) async {
    UserCustom? user = await userService.getUser(email);
    if (user != null)
      Navigator.pushNamed(context, OtherUserScreen.id,
          arguments: OtherUserScreenArguments(user));
    else
      CustomAlert()
          .showMyDialog(context, 'Other user', 'Error getting user info');
  }

  goToUserProfile() {
    Navigator.pushNamed(context, UserScreen.id);
  }

  Future<void> downloadFileExampleAndShare() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/share-image.png');
    String imageRef = announcement.images.first.split('o/').last;
    imageRef = imageRef.split('?').first.replaceAll('%2F', '/');
    try {
      await FirebaseStorage.instance
          .ref(imageRef)
          .writeToFile(downloadToFile);
      await Share.shareFiles( [downloadToFile.path], text: announcement.description, subject: announcement.title);
    } on FirebaseException catch (e) {
      CustomAlert()
          .showMyDialog(context, 'Erros downloading image to share', e.message.toString());
    }
  }
  
}
