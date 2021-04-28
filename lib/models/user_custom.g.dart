// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCustom _$UserCustomFromJson(Map<String, dynamic> json) {
  return UserCustom(
    json['name'] as String,
    json['email'] as String,
    json['password'] as String,
    DateTime.parse(json['date'] as String),
    json['radius'] as int,
    json['telefon'] as int,
    json['show'] as bool,
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['reports'] as int,
  );
}

Map<String, dynamic> _$UserCustomToJson(UserCustom instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'date': instance.date.toIso8601String(),
      'radius': instance.radius,
      'telefon': instance.telefon,
      'show': instance.show,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'reports': instance.reports,
    };
