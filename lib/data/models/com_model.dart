import 'package:cloud_firestore/cloud_firestore.dart';

class CommissionModel {
  String? id;
  String? uid;
  String? phone;
  String? name;
  String? email;
  double? amount;

  double? fromVolume;
  String? fromUid;
  String? fromPhone;
  String? fromEmail;
  String? fromName;

  int? gen;
  String? note;
  String? type;
  String? wallet;
  String? site;
  Timestamp? timeCreated;
  String? wSave;
  bool? t;
  CommissionModel({
    this.id,
    this.uid,
    this.phone,
    this.name,
    this.email,
    this.amount,
    this.fromVolume,
    this.fromUid,
    this.fromPhone,
    this.fromEmail,
    this.fromName,
    this.gen,
    this.note,
    this.type,
    this.wallet,
    this.site,
    this.timeCreated,
    this.wSave,
    this.t,
  });

  CommissionModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    uid = documentSnapshot.data()!['uid'] as String? ?? '';
    phone = documentSnapshot.data()!['phone'] as String? ?? '';
    name = documentSnapshot.data()!['name'] as String? ?? '';
    email = documentSnapshot.data()!['email'] as String? ?? '';
    amount = documentSnapshot.data()!['amount'] as double? ?? 0.0;

    fromVolume = documentSnapshot.data()!['fromVolume'] as double? ?? 0.0;
    fromUid = documentSnapshot.data()!['fromUid'] as String? ?? '';
    fromPhone = documentSnapshot.data()!['fromPhone'] as String? ?? '';
    fromEmail = documentSnapshot.data()!['fromEmail'] as String? ?? '';
    fromName = documentSnapshot.data()!['fromName'] as String? ?? '';

    gen = documentSnapshot.data()!['gen'] ?? 0;
    note = documentSnapshot.data()!['note'] as String? ?? '';
    type = documentSnapshot.data()!['type'] as String? ?? '';
    wallet = documentSnapshot.data()!['wallet'] as String? ?? '';
    site = documentSnapshot.data()!['site'] as String? ?? '';

    timeCreated = documentSnapshot.data()!['timeCreated'];
    t = documentSnapshot.data()!['t'] ?? false;
    wSave = documentSnapshot.data()!['wSave'] ?? '';
  }
}
