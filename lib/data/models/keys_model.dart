import 'package:cloud_firestore/cloud_firestore.dart';

class KeyModel {
  String? id;
  String? uidClient;
  String? address;
  String? symbol;
  String? privateKey;

  KeyModel({
    this.id,
    this.uidClient,
    this.address,
    this.symbol,
    this.privateKey,
  });

  KeyModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    uidClient = documentSnapshot.data()!['uidClient'] ?? '';
    address = documentSnapshot.data()!['address'] ?? '';
    symbol = documentSnapshot.data()!['symbol'] ?? '';
    privateKey = documentSnapshot.data()!['privateKey'] ?? '';
  }
}
