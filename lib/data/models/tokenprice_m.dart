// To parse this JSON data, do
//
//     final tokenPricePk = tokenPricePkFromJson(jsonString);

import 'dart:convert';

TokenPricePk tokenPricePkFromJson(String str) => TokenPricePk.fromJson(json.decode(str));

String tokenPricePkToJson(TokenPricePk data) => json.encode(data.toJson());

class TokenPricePk {
  TokenPricePk({
    this.updatedAt,
    this.data,
  });

  int? updatedAt;
  Data? data;

  factory TokenPricePk.fromJson(Map<String, dynamic> json) => TokenPricePk(
        updatedAt: json["updated_at"] ?? 0,
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "updated_at": updatedAt,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.name,
    this.symbol,
    this.priceUsd,
    this.priceBnb,
  });

  String? name;
  String? symbol;
  double? priceUsd;
  double? priceBnb;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"] ?? '',
        symbol: json["symbol"] ?? '',
        priceUsd: double.parse(json["price"] ?? 0),
        priceBnb: double.parse(json["price_BNB"] ?? 0),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "price": priceUsd,
        "price_BNB": priceBnb,
      };
}
