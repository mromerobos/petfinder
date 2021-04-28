import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(explicitToJson: true)
class Report {
  @JsonKey(ignore: true)
  late String id;
  int user_email;
  int rep_user_email;
  DateTime date;

  Report(this.user_email, this.rep_user_email, this.date);

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
