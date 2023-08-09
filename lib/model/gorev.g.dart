// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gorev.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gorev _$GorevFromJson(Map<String, dynamic> json) => Gorev(
      name: json['name'] as String,
      durum: json['durum'] == 1 ? true : false,
      dutyTypeid: json['dutyTypeid'] as int,
    )..id = json['id'] as int?;

Map<String, dynamic> _$GorevToJson(Gorev instance) => <String, dynamic>{
      'name': instance.name,
      'durum': instance.durum == true ? 1 : 0,
      'dutyTypeid': instance.dutyTypeid,
    };
