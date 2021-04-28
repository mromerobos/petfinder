import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(ignore: true)
  late String id;
  String announce_id;
  String author_email;
  String author_name;
  String description;
  DateTime date;
  double latitude;
  double longitude;
  List<String> images;

  Comment(this.description, this.announce_id,this.author_email,this.author_name, this.date, this.latitude, this.longitude,
      this.images);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
