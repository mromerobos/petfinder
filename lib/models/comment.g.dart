// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    json['description'] as String,
    json['announce_id'] as String,
    json['author_email'] as String,
    json['author_name'] as String,
    DateTime.parse(json['date'] as String),
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'announce_id': instance.announce_id,
      'author_email': instance.author_email,
      'author_name': instance.author_name,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'images': instance.images,
    };
