import 'package:flutter/material.dart';
import 'package:petfinder/commons/arguments.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/models/user_custom.dart';
import 'package:petfinder/screens/user_screen.dart';
import 'package:petfinder/widgets/top_bar_custom.dart';

class OtherUserScreen extends StatefulWidget {
  static const String id = 'other_user_screen';

  @override
  _OtherUserScreenState createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  late UserCustom user;
  String userImage = '';
  double lat = 41.922253;
  double lon = 2.800897;

  @override
  Widget build(BuildContext context) {
    final OtherUserScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as OtherUserScreenArguments;
    user = args.user;
    return Scaffold(
      appBar: TopBarCustom(
        icon: Icons.person,
        title: 'User profile',
        onTap: goToUserProfile,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  (userImage.length > 0)
                      ? userImage
                      : 'assets/images/abstract-866.png',
                  width: 125,
                ),
                Container(
                  width: 200,
                  child: Text(
                    user.name,
                    style: normalText,
                  ),
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: ElevatedButton(
                    onPressed: reportUser,
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.report,
                              color: Colors.black,
                            )),
                        Text(
                          'Report User',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reportUser() {
  }

  void goToUserProfile() {
    Navigator.pushNamed(context, UserScreen.id);
  }
}
