// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map<String, dynamic> json) {
  return Follow(
    json['user_email'] as String,
    json['announce_id'] as String,
    DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'user_email': instance.user_email,
      'announce_id': instance.announce_id,
      'date': instance.date.toIso8601String(),
    };
