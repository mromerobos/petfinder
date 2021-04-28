// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) {
  return Report(
    json['user_email'] as int,
    json['rep_user_email'] as int,
    DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'user_email': instance.user_email,
      'rep_user_email': instance.rep_user_email,
      'date': instance.date.toIso8601String(),
    };
