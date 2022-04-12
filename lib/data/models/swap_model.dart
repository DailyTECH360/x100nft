import 'package:cloud_firestore/cloud_firestore.dart';

class SwapModel {
  String? id;
  String? uid;
  String? name;
  String? phone;

  double? amountUSD;
  double? amountPAS;
  double? cryptoRate;

  String? address;
  String? txhash;

  String? status; //pending-cancel-done
  String? note;

  Timestamp? timeCreated;
  Timestamp? timeGetPas;
  bool? t;

  SwapModel({
    this.id,
    this.uid,
    this.name,
    this.phone,
    this.amountUSD,
    this.amountPAS,
    this.cryptoRate,
    this.status,
    this.address,
    this.txhash,
    this.note,
    this.timeCreated,
    this.timeGetPas,
    this.t,
  });

  SwapModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    id = docSnap.id;
    uid = docSnap.data()!['uid'] ?? '';
    name = docSnap.data()!['name'] ?? '';
    phone = docSnap.data()!['phone'] ?? '';

    amountUSD = docSnap.data()!['amountUSD'] as double? ?? 0.0;
    amountPAS = docSnap.data()!['amountPAS'] as double? ?? 0.0;
    cryptoRate = docSnap.data()!['cryptoRate'] as double? ?? 0.0;

    address = docSnap.data()!['address'] ?? '';
    txhash = docSnap.data()!['txhash'] ?? '';

    status = docSnap.data()!['status'] ?? '';
    note = docSnap.data()!['note'] ?? '';

    timeCreated = docSnap.data()!['timeCreated'] ?? Timestamp.now();
    timeGetPas = docSnap.data()!['timeGetPas'] ?? Timestamp.now();
    t = docSnap.data()!['t'] ?? false;
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'amountUSD': amountUSD,
        'amountPAS': amountPAS,
        'cryptoRate': cryptoRate,
        'status': status ?? 'pending',
        'address': address,
        'txhash': '',
        'note': note ?? '',
        'timeCreated': Timestamp.now(),
        'timeGetPas': Timestamp.now(),
        't': t ?? false,
      };
}
