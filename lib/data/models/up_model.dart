import 'package:flutter/material.dart';

class UserPModel {
  String? phone;
  String? name;
  String? email;
  String? fb;
  String? tele;
  String? zalo;
  String? bio;
  String? info;

  UserPModel({
    Key? key,
    this.phone,
    this.name,
    this.email,
    this.fb,
    this.tele,
    this.zalo,
    this.bio,
    this.info,
  });

  UserPModel.fromDocumentSnapshot({required Map<String, dynamic> doc}) {
    name = doc['name'] ?? '';
    phone = doc['phone'] ?? '';
    email = doc['email'] ?? '';
    fb = doc['fb'] ?? '';
    tele = doc['tele'] ?? '';
    zalo = doc['zalo'] ?? '';
    bio = doc['bio'] ?? '';
    info = doc['info'] ?? '';
  }
}
