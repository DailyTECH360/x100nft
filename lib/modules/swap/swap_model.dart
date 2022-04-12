import 'package:cloud_firestore/cloud_firestore.dart';

class SwapModel {
  String? id;
  String? uid;
  String? name;
  String? email;
  String? phone;

  double? amountFrom;
  double? amountTo;
  double? rate;
  double? fee;

  String? note;

  Timestamp? timeCreated;
  Timestamp? timeGetPas;
  bool? t;

  SwapModel({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.amountFrom,
    this.amountTo,
    this.rate,
    this.fee,
    this.note,
    this.timeCreated,
    this.timeGetPas,
    this.t,
  });

  SwapModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> docSnap}) {
    id = docSnap.id;
    uid = docSnap.data()!["uid"] ?? '';
    name = docSnap.data()!["name"] ?? '';
    email = docSnap.data()!["email"] ?? '';
    phone = docSnap.data()!["phone"] ?? '';

    amountFrom = docSnap.data()!['amountFrom'] as double? ?? 0.0;
    amountTo = docSnap.data()!["amountTo"] as double? ?? 0.0;
    rate = docSnap.data()!["rate"] as double? ?? 0.0;
    fee = docSnap.data()!["fee"] ?? 0;

    note = docSnap.data()!["note"] ?? '';

    timeCreated = docSnap.data()!["timeCreated"] ?? Timestamp.now();
    timeGetPas = docSnap.data()!["timeGetPas"] ?? Timestamp.now();
    t = docSnap.data()!["t"] ?? false;
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'email': email,
        'amountFrom': amountFrom,
        'amountTo': amountTo,
        'rate': rate,
        'fee': fee,
        'note': note ?? '',
        'timeCreated': Timestamp.now(),
        'timeGetPas': Timestamp.now(),
        't': t ?? false,
      };
}
