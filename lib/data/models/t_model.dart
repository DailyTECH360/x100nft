import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsModel {
  String? id;
  double? amount;
  double? fee;
  double? rate;

  String? status; //pending-cancel-done
  String? type;
  String? note;

  String? uUid;
  String? uName;
  String? uOtherUid;
  String? uOtherName;

  String? symbol;
  String? wallet;

  int? timeMilis;
  bool? t;

  TransactionsModel({
    this.id,
    this.amount,
    this.fee,
    this.rate,
    this.status,
    this.type,
    this.note,
    this.uUid,
    this.uName,
    this.uOtherUid,
    this.uOtherName,
    this.symbol,
    this.wallet,
    this.timeMilis,
    this.t,
  });

  TransactionsModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    id = docSnap.id;
    amount = docSnap.data()!['amount'] as double? ?? 0;
    fee = docSnap.data()!['fee'] as double? ?? 0;
    rate = docSnap.data()!['rate'] as double? ?? 0;

    status = docSnap.data()!['status'] ?? '';
    type = docSnap.data()!['type'] ?? '';
    note = docSnap.data()!['note'] ?? '';

    uUid = docSnap.data()!['uUid'] ?? '';
    uName = docSnap.data()!['uName'] ?? '';
    uOtherUid = docSnap.data()!['uOtherUid'] ?? '';
    uOtherName = docSnap.data()!['uOtherName'] ?? '';

    symbol = docSnap.data()!['symbol'] ?? '';
    wallet = docSnap.data()!['wallet'] ?? '';

    timeMilis = docSnap.data()!['timeMilis'] ?? Timestamp.now().millisecondsSinceEpoch;
    t = docSnap.data()!['t'] ?? false;
  }
}
