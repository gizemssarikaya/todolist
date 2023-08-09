import 'package:json_annotation/json_annotation.dart';
part 'gorev.g.dart';

@JsonSerializable()
class Gorev {
  int? id;
  late String name;
  late bool durum;
  late int dutyTypeid;

  Gorev( {required this.name, required this.durum, required this.dutyTypeid});

  factory Gorev.fromJson(Map<String, dynamic> map) => _$GorevFromJson(map);

  Map<String, dynamic> toJSon() => _$GorevToJson(this);
}
