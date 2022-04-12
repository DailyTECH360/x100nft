import 'package:cloud_firestore/cloud_firestore.dart';

class AgentRModel {
  String? id;
  double? comAgent;
  String? status;

  String? uid;
  String? uidF1;

  double? uidComMax;
  double? uidComF1Max;

  Timestamp? timestamp;
  Timestamp? timeConfirm;
  String? byAdmin;

  AgentRModel({
    this.id,
    this.comAgent,
    this.status,
    this.uid,
    this.uidF1,
    this.uidComMax,
    this.uidComF1Max,
    this.timestamp,
    this.timeConfirm,
    this.byAdmin,
  });

  AgentRModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;
    comAgent = documentSnapshot.data()!['comAgent'] ?? 0;
    status = documentSnapshot.data()!['status'] ?? '';

    uid = documentSnapshot.data()!['uid'] as String? ?? '';
    uidF1 = documentSnapshot.data()!['uidF1'] as String? ?? '';

    uidComMax = documentSnapshot.data()!['uidComMax'] ?? 0;
    uidComF1Max = documentSnapshot.data()!['uidComF1Max'] ?? 0;

    timestamp = documentSnapshot.data()!['timestamp'] ?? Timestamp.now();
    timeConfirm = documentSnapshot.data()!['timeConfirm'] ?? Timestamp.now();

    byAdmin = documentSnapshot.data()!['byAdmin'] ?? '';
  }
}
