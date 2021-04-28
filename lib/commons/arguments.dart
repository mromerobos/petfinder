
import 'package:petfinder/models/announcement.dart';
import 'package:petfinder/models/user_custom.dart';

class AddScreenArguments {
  final bool isAdd;
  final String id;

  AddScreenArguments(this.isAdd, this.id);
}

class AnnouncementScreenArguments {
  final Announcement announcement;

  AnnouncementScreenArguments(this.announcement);
}

class OtherUserScreenArguments {
  final UserCustom user;

  OtherUserScreenArguments(this.user);
}

typedef void OnSearchCallback(String? text, int? radius, DateTime? from, DateTime? to);