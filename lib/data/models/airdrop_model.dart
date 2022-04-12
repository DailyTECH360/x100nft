import 'package:cloud_firestore/cloud_firestore.dart';

class AirDropModel {
  String? id;
  String? uid;
  String? name;
  String? email;
  String? uidSpon;

  String? addr;
  double? amountToken;
  double? amountUsd;

  double? cryptoAmount;
  double? cryptoRate;
  String? cryptoSymbol;

  String? txhashPay;
  String? type;
  String? note;
  Timestamp? timeCreated;
  bool? t;
  bool? comRun;

  AirDropModel({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.uidSpon,
    this.addr,
    this.amountToken,
    this.amountUsd,
    this.cryptoAmount,
    this.cryptoRate,
    this.cryptoSymbol,
    this.txhashPay,
    this.type,
    this.note,
    this.timeCreated,
    this.t,
    this.comRun,
  });

  AirDropModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    uid = documentSnapshot.data()!['uid'] ?? '';
    name = documentSnapshot.data()!['name'] ?? '';
    email = documentSnapshot.data()!['email'] ?? '';
    uidSpon = documentSnapshot.data()!['uidSpon'] ?? '';
    addr = documentSnapshot.data()!['addr'] ?? '';

    amountToken = documentSnapshot.data()!['amountToken'] as double? ?? 0;
    amountUsd = documentSnapshot.data()!['amountUsd'] as double? ?? 0;

    cryptoAmount = documentSnapshot.data()!['cryptoAmount'] as double? ?? 0;
    cryptoRate = documentSnapshot.data()!['cryptoRate'] as double? ?? 0;
    cryptoSymbol = documentSnapshot.data()!['cryptoSymbol'] as String? ?? '';

    txhashPay = documentSnapshot.data()!['txhashPay'] ?? '';
    type = documentSnapshot.data()!['type'] ?? '';
    note = documentSnapshot.data()!['note'] ?? '';
    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
    t = documentSnapshot.data()!['t'] ?? false;
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'uidSpon': uidSpon,
        'addr': addr,
        'amountToken': amountToken,
        'amountUsd': amountUsd,
        'cryptoAmount': cryptoAmount,
        'cryptoRate': cryptoRate,
        'cryptoSymbol': cryptoSymbol,
        'txhashPay': txhashPay ?? '',
        'type': type ?? '',
        'note': note ?? '',
        'timeCreated': Timestamp.now(),
        't': t ?? false,
        'comRun': comRun ?? true,
      };
}
