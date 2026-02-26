import 'package:json_annotation/json_annotation.dart';

class StringFromAnyConverter implements JsonConverter<String?, dynamic> {
  const StringFromAnyConverter();

  @override
  String? fromJson(dynamic json) => json?.toString();

  @override
  dynamic toJson(String? object) => object;
}
