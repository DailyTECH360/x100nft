import 'package:cloud_firestore/cloud_firestore.dart';

class DepModel {
  String? id;

  String? uidClient;
  String? phone;
  String? name;
  String? email;

  double? amount;
  double? amountUsdt;
  String? tokenName;
  String? tokenSymbol;
  String? from;
  String? to;

  String? txhash;
  int? status;
  bool? copy;

  int? timestamp;

  Timestamp? confirmAt;

  DepModel({
    this.id,
    this.uidClient,
    this.phone,
    this.name,
    this.email,
    this.amount,
    this.amountUsdt,
    this.tokenName,
    this.tokenSymbol,
    this.from,
    this.to,
    this.txhash,
    this.status,
    this.copy,
    this.timestamp,
    this.confirmAt,
  });

  DepModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    id = docSnap.id;
    uidClient = docSnap.data()!['uidClient'] ?? '';

    phone = docSnap.data()!['phone'] ?? '';
    name = docSnap.data()!['name'] ?? '';
    email = docSnap.data()!['email'] ?? '';

    amount = docSnap.data()!['amount'] as double? ?? 0.0;
    amountUsdt = docSnap.data()!['amountUsdt'] as double? ?? 0.0;
    tokenName = docSnap.data()!['tokenName'] ?? '';
    tokenSymbol = docSnap.data()!['tokenSymbol'] ?? '';
    from = docSnap.data()!['from'] ?? '';
    to = docSnap.data()!['to'] ?? '';
    txhash = docSnap.data()!['txhash'] ?? '';
    status = docSnap.data()!['status'] as int? ?? 0;

    copy = docSnap.data()!['copy'] ?? false;
    timestamp = docSnap.data()!['timestamp'] as int? ?? 0;

    confirmAt = docSnap.data()!['confirmAt'] as Timestamp? ?? Timestamp.now();
  }
}
