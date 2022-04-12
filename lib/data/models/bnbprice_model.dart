import 'dart:convert';

BnbPriceModel bnbPriceFromJson(String str) => BnbPriceModel.fromJson(json.decode(str));

// String bnbPriceToJson(BnbPrice data) => json.encode(data.toJson());

class BnbPriceModel {
  String? status;
  String? message;
  PriceOj? priceOj;
  BnbPriceModel({this.status, this.message, this.priceOj});

  factory BnbPriceModel.fromJson(Map<String, dynamic> json) => BnbPriceModel(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        priceOj: PriceOj.fromJson(json["result"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": priceOj!.toJson(),
      };
}

class PriceOj {
  double? bnbbtc;
  String? ethbtcTimestamp;
  double? bnbusd;
  String? ethusdTimestamp;

  PriceOj({this.bnbbtc, this.ethbtcTimestamp, this.bnbusd, this.ethusdTimestamp});

  factory PriceOj.fromJson(Map<String, dynamic> json) => PriceOj(
        bnbbtc: double.parse(json["ethbtc"] ?? '0'),
        ethbtcTimestamp: json["ethbtc_timestamp"] ?? '',
        bnbusd: double.parse(json["ethusd"] ?? '0'),
        ethusdTimestamp: json["ethusd_timestamp"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ethbtc": bnbbtc,
        "ethbtc_timestamp": ethbtcTimestamp,
        "ethusd": bnbusd,
        "ethusd_timestamp": ethusdTimestamp,
      };
}
