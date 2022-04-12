// To parse this JSON data, do
//     final countries = countriesFromJson(jsonString);

import 'dart:convert';

List<Countries> countriesFromJson(String str) => List<Countries>.from(json.decode(str).map((x) => Countries.fromJson(x)));

class Countries {
  Countries({
    this.name,
    this.dialCode,
    this.code,
    this.flag,
  });

  String? name;
  String? dialCode;
  String? code;
  String? flag;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
        name: json['name'] ?? '',
        dialCode: json['dial_code'] ?? '',
        code: json['code'] ?? '',
        flag: json['flag'] ?? '',
      );
}
