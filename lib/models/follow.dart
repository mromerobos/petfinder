import 'package:json_annotation/json_annotation.dart';

part 'follow.g.dart';

@JsonSerializable(explicitToJson: true)
class Follow {
  @JsonKey(ignore: true)
  late String id;
  String user_email;
  String announce_id;
  DateTime date;

  Follow(this.user_email, this.announce_id, this.date);

  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  Map<String, dynamic> toJson() => _$FollowToJson(this);
}
