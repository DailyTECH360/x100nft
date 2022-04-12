import 'package:cloud_firestore/cloud_firestore.dart';

class LogWModel {
  String? id;
  String? uid;
  String? name;
  String? email;
  String? phone;

  double? wPs;
  double? wUsdNew;
  double? wUsdOld;
  String? wallet;
  bool? t;
  Timestamp? timeCreated;

  LogWModel({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.wPs,
    this.wUsdNew,
    this.wUsdOld,
    this.wallet,
    this.t,
    this.timeCreated,
  });

  LogWModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    uid = documentSnapshot.data()!['uid'] ?? '';
    name = documentSnapshot.data()!['name'] ?? '';
    email = documentSnapshot.data()!['email'] ?? '';
    phone = documentSnapshot.data()!['phone'] ?? '';
    wPs = documentSnapshot.data()!['wPs'] ?? 0;
    wUsdNew = documentSnapshot.data()!['wUsdNew'] ?? 0;
    wUsdOld = documentSnapshot.data()!['wUsdOld'] ?? 0;
    wallet = documentSnapshot.data()!['wallet'] ?? '';
    t = documentSnapshot.data()!['t'] ?? false;
    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
  }
}
