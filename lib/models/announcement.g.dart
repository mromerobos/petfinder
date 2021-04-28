// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  return Announcement(
    json['author_email'] as String,
    json['author_name'] as String,
    json['author_tel'] as String,
    json['author_show'] as bool,
    json['title'] as String,
    json['description'] as String,
    DateTime.parse(json['date'] as String),
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'author_email': instance.author_email,
      'author_name': instance.author_name,
      'author_tel': instance.author_tel,
      'author_show': instance.author_show,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'images': instance.images,
    };
