// To parse this JSON data, do
//
//     final getMyIp = getMyIpFromJson(jsonString);

import 'dart:convert';

GetMyIp getMyIpFromJson(String str) => GetMyIp.fromJson(json.decode(str));
String getMyIpToJson(GetMyIp data) => json.encode(data.toJson());

class GetMyIp {
  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? getMyIpAs;
  String? query;

  GetMyIp({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.getMyIpAs,
    this.query,
  });

  factory GetMyIp.fromJson(Map<String, dynamic> json) => GetMyIp(
        status: json['status'] ?? '',
        country: json['country'] ?? '',
        countryCode: json['countryCode'] ?? '',
        region: json['region'] ?? '',
        regionName: json['regionName'] ?? '',
        city: json['city'] ?? '',
        zip: json['zip'] ?? '',
        lat: json['lat'].toDouble(),
        lon: json['lon'].toDouble(),
        timezone: json['timezone'] ?? '',
        isp: json['isp'] ?? '',
        org: json['org'] ?? '',
        getMyIpAs: json['as'] ?? '',
        query: json['query'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'country': country,
        'countryCode': countryCode,
        'region': region,
        'regionName': regionName,
        'city': city,
        'zip': zip,
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'isp': isp,
        'org': org,
        'as': getMyIpAs,
        'query': query,
      };
}
