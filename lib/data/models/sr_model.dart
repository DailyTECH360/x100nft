import 'package:cloud_firestore/cloud_firestore.dart';

class SellRoundModel {
  int? number;
  double? total;
  double? price;
  String? symbol;
  Timestamp? timeStart;
  Timestamp? timeEnd;

  SellRoundModel({
    this.number,
    this.total,
    this.price,
    this.symbol,
    this.timeStart,
    this.timeEnd,
  });
  SellRoundModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    number = documentSnapshot.data()!['number'] ?? 1;
    total = documentSnapshot.data()!['total'] ?? 0;
    price = documentSnapshot.data()!['price'] ?? 0;
    symbol = documentSnapshot.data()!['symbol'] ?? '';
    timeStart = documentSnapshot.data()!['timeStart'] ?? Timestamp.now();
    timeEnd = documentSnapshot.data()!['timeEnd'] ?? Timestamp.now();
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'total': total,
        'price': price,
        'symbol': symbol,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
      };
}
