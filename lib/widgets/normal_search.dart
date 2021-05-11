import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petfinder/commons/custom_loading.dart';
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/services/announcement_service.dart';
import 'package:petfinder/services/user_service.dart';
import 'package:petfinder/widgets/announcement_min.dart';
import 'package:petfinder/widgets/filter.dart';

class NormalSearch extends StatefulWidget {

  NormalSearch({Key? key, required this.callback}) : super(key: key);

  final callback;

  @override
  _NormalSearchState createState() => _NormalSearchState();
}

class _NormalSearchState extends State<NormalSearch> with AutomaticKeepAliveClientMixin<NormalSearch> {

  AnnouncementService announcementService = AnnouncementService();
  UserService userService = UserService();

  List<Announcement> list = [];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Filter(loading: false, onPressed: (String? text, int? radius, DateTime? from, DateTime? to) => searchAction(text, radius, from, to)),
        Expanded(
          child: (loading)? Center(child: Container(width: 100, height: 100, child: CircularProgressIndicator())) : Container(
            margin: EdgeInsets.all(5),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return AnnouncementMin(announcement: list[index], onTap: (val) => widget.callback(val),);
                    },
                    childCount: list.length,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> searchAction(String? text, int? radius, DateTime? from, DateTime? to) async {
    setState(() {
      loading = true;
    });
    Position position = await Geolocator.getCurrentPosition();
    list = await announcementService.getAnnouncements(text, radius, position, from, to);
    setState(() {
      loading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
