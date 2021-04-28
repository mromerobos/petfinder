import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable(explicitToJson: true)
class Announcement {
  @JsonKey(ignore: true)
  late String id;
  String author_email;
  String author_name;
  String author_tel;
  bool author_show;
  String title;
  String description;
  DateTime date;
  double latitude;
  double longitude;
  List<String> images;

  Announcement(this.author_email,this.author_name,this.author_tel,this.author_show,this.title, this.description, this.date, this.latitude,
      this.longitude, this.images);

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
