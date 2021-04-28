import 'package:flutter/material.dart';
import 'package:petfinder/commons/arguments.dart';
import 'package:petfinder/commons/custom_alert.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/screens/user_screen.dart';
import 'package:petfinder/services/announcement_service.dart';
import 'package:petfinder/widgets/map_search.dart';
import 'package:petfinder/widgets/normal_search.dart';

import 'add_screen.dart';
import 'announcement_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'nav_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<String> currentPage = ['Normal Search', 'Maps Search', 'Donations'];
  int currentIndex = 1;

  AnnouncementService announcementService = AnnouncementService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Center(child: Text(currentPage[currentIndex])),
            actions: [
              Material(
                  color: Colors.transparent,
                  child: IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () => goToUserProfile()))
            ],
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              tabs: [
                Tab(icon: Icon(Icons.search)),
                Tab(icon: Icon(Icons.map_outlined)),
                Tab(icon: Icon(Icons.payment)),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              NormalSearch(callback: (val) => goToAnnouncement(val)),
              MapSearch(callback: (val) => goToAnnouncement(val)),
              Container(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: goToAdd,
            child: const Icon(Icons.add_comment_outlined),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }

  Future<void> goToAnnouncement(String id) async {
    Announcement? announcement = await announcementService.getAnnouncement(id);
    if (announcement != null)
      Navigator.pushNamed(context, AnnouncementScreen.id,
          arguments: AnnouncementScreenArguments(announcement));
    else {
      CustomAlert().showMyDialog(context, 'Opening Announcement',
          'Some error occurred when getting data from server');
    }
  }

  void goToUserProfile() {
    Navigator.pushNamed(context, UserScreen.id);
  }

  goToAdd() async {
    final dynamic? id = await Navigator.pushNamed(context, AddScreen.id,
        arguments: AddScreenArguments(true, ''));
    if (id != null) {
      Announcement? announcement =
          await announcementService.getAnnouncement(id);
      if (announcement != null)
        Navigator.pushNamed(context, AnnouncementScreen.id,
            arguments: AnnouncementScreenArguments(announcement));
      else {
        CustomAlert().showMyDialog(context, 'Opening Announcement',
            'Some error occurred when getting data from server');
      }
    }
  }
}
