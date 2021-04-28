import 'package:json_annotation/json_annotation.dart';

part 'user_custom.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCustom {
  @JsonKey(ignore: true)
  late String id;
  String name;
  String email;
  String password;
  DateTime date;
  int radius;
  int telefon;
  bool show;
  double latitude;
  double longitude;
  int reports;

  UserCustom(this.name, this.email,this.password, this.date, this.radius, this.telefon, this.show,
      this.latitude, this.longitude, this.reports);

  factory UserCustom.fromJson(Map<String, dynamic> json) => _$UserCustomFromJson(json);

  Map<String, dynamic> toJson() => _$UserCustomToJson(this);
}
