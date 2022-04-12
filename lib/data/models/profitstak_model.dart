import 'package:cloud_firestore/cloud_firestore.dart';

class ProfitStakModel {
  String? id;
  String? stakId;

  double? stakAmount;
  double? profitDay;
  double? rateD;
  int? getDoneDay;

  String? uid;
  String? wallet;
  String? symbol;
  Timestamp? timeCreated;
  bool? t;

  ProfitStakModel({
    this.id,
    this.stakId,
    this.getDoneDay,
    this.stakAmount,
    this.profitDay,
    this.rateD,
    this.uid,
    this.wallet,
    this.symbol,
    this.timeCreated,
    this.t,
  });

  ProfitStakModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    uid = documentSnapshot.data()!['uid'] as String? ?? '';

    stakId = documentSnapshot.data()!['stakId'] as String? ?? '';
    stakAmount = documentSnapshot.data()!['stakAmount'] as double? ?? 0;

    profitDay = documentSnapshot.data()!['profitDay'] as double? ?? 0;
    rateD = documentSnapshot.data()!['rateD'] as double? ?? 0;
    getDoneDay = documentSnapshot.data()!['getDoneDay'] as int? ?? 0;

    wallet = documentSnapshot.data()!['wallet'] as String? ?? '';
    symbol = documentSnapshot.data()!['symbol'] as String? ?? '';
    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
    t = documentSnapshot.data()!['t'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'stakId': stakId,
        'stakAmount': stakAmount,
        'profitDay': profitDay,
        'rateD': rateD,
        'getDoneDay': getDoneDay,
        'wallet': wallet,
        'uid': uid,
        'timeCreated': timeCreated,
        't': t,
      };
}
