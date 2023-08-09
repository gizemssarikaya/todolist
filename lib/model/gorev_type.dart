import 'package:json_annotation/json_annotation.dart';
part 'gorev_type.g.dart';

@JsonSerializable()
class GorevType {
  String name;
  int? id;

  GorevType(this.id, {required this.name});

  factory GorevType.fromJson(Map<String, dynamic> map) =>
      _$GorevTypeFromJson(map);

  Map<String, dynamic> toJson() => _$GorevTypeToJson(this);
}
