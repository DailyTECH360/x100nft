import 'package:cloud_firestore/cloud_firestore.dart';

class LendingModel {
  String? id;
  String? symbol;
  double? amount;
  double? rateD;
  int? cycleDay;
  int? getDoneDay;
  double? getDoneAmount;
  String? status = 'run'; // pending || end || lock
  String? uid;
  String? name;
  Timestamp? timeCreated;
  bool? t;

  LendingModel({
    this.id,
    this.symbol,
    this.amount,
    this.rateD,
    this.cycleDay,
    this.getDoneDay,
    this.getDoneAmount,
    this.status,
    this.uid,
    this.name,
    this.timeCreated,
    this.t,
  });

  LendingModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    amount = documentSnapshot.data()!['amount'] as double? ?? 0;
    symbol = documentSnapshot.data()!['symbol'] ?? '';
    rateD = documentSnapshot.data()!['rateD'] as double? ?? 0;
    cycleDay = documentSnapshot.data()!['cycleDay'] as int? ?? 0;

    getDoneDay = documentSnapshot.data()!['getDoneDay'] as int? ?? 0;
    getDoneAmount = documentSnapshot.data()!['getDoneAmount'] as double? ?? 0;
    status = documentSnapshot.data()!['status'] ?? '';

    uid = documentSnapshot.data()!['uid'] ?? '';
    name = documentSnapshot.data()!['name'] ?? '';
    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
    t = documentSnapshot.data()!['t'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'amount': amount ?? 0,
        'rateD': rateD ?? 0,
        'symbol': symbol ?? 'USD',
        'cycleDay': cycleDay ?? 0,
        'getDoneDay': getDoneDay ?? 0,
        'getDoneAmount': getDoneAmount ?? 0,
        'status': status ?? 'run',
        'uid': uid,
        'name': name ?? '',
        'timeCreated': timeCreated ?? Timestamp.now(),
      };
}
