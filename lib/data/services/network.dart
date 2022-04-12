import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkHttp {
  final String url;
  NetworkHttp(this.url);

  Future<String> apiRequest(Map jsonMap) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/x-www-form-urlencoded');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<String> sendData(Map data) async {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return '';
    }
  }

  Future<String> getDataPost() async {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return '';
    }
  }

  Future<String> getDataJson() async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      // headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return '';
    }
  }
}

// Future<String> getMyIp() async {
// String checkIpApiLink = 'http://ip-api.com/json';
//   var network = NetworkHttp(checkIpApiLink);
//   var str = await network.getData();
//   GetMyIp myIpData = getMyIpFromJson(str);
//   debugPrint('MyIP: ${myIpData.query!}');
//   return myIpData.query!;
// }