import 'package:cloud_firestore/cloud_firestore.dart';

class TranModel {
  String? id;
  double? amount;
  double? amountToken;
  double? fee;

  String? uid;
  String? name;
  String? phone;
  String? email;

  String? otherUid;
  String? otherPhone;
  String? otherName;
  String? otherEmail;

  String? type;
  String? status; //pending-cancel-done
  String? addressW;
  String? txhash;
  String? wallet;
  bool? t;
  bool? debit;
  Timestamp? timeCreated;
  TranModel({
    this.id,
    this.amount,
    this.amountToken,
    this.fee,
    this.uid,
    this.name,
    this.phone,
    this.email,
    this.otherUid,
    this.otherName,
    this.otherPhone,
    this.otherEmail,
    this.type,
    this.status,
    this.addressW,
    this.txhash,
    this.wallet,
    this.t,
    this.debit,
    this.timeCreated,
  });

  TranModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    id = docSnap.id;
    amount = docSnap.data()!['amount'] as double? ?? 0;
    amountToken = docSnap.data()!['amountToken'] as double? ?? 0;
    fee = docSnap.data()!['fee'] as double? ?? 0;

    uid = docSnap.data()!['uid'] ?? '';
    name = docSnap.data()!['name'] ?? '';
    phone = docSnap.data()!['phone'] ?? '';
    email = docSnap.data()!['email'] ?? '';

    otherUid = docSnap.data()!['otherUid'] ?? '';
    otherPhone = docSnap.data()!['otherPhone'] ?? '';
    otherName = docSnap.data()!['otherName'] ?? '';
    otherEmail = docSnap.data()!['otherEmail'] ?? '';

    t = docSnap.data()!['t'] ?? false;
    debit = docSnap.data()!['debit'] ?? false;
    type = docSnap.data()!['type'] ?? '';
    status = docSnap.data()!['status'] ?? '';
    addressW = docSnap.data()!['addressW'] ?? '';
    txhash = docSnap.data()!['txhash'] ?? '';
    wallet = docSnap.data()!['wallet'] ?? '';

    timeCreated = docSnap.data()!['timeCreated'] ?? Timestamp.now();
  }
}
