import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  Timestamp? timeCreated;
  String? content;
  String? title;
  String? uid;
  String? fromUid;
  String? fromName;
  String? fromPhone;
  String? fromEmail;

  bool? read;
  String? id;

  NoticeModel({
    this.timeCreated,
    this.content,
    this.title,
    this.uid,
    this.fromUid,
    this.fromName,
    this.fromPhone,
    this.fromEmail,
    this.read,
    this.id,
  });

  NoticeModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    id = documentSnapshot.id;

    content = documentSnapshot.data()!['content'] ?? '';
    title = documentSnapshot.data()!['title'] ?? '';
    uid = documentSnapshot.data()!['uid'] ?? '';
    fromUid = documentSnapshot.data()!['fromUid'] ?? '';
    fromPhone = documentSnapshot.data()!['fromPhone'] ?? '';
    fromName = documentSnapshot.data()!['fromName'] ?? '';
    fromEmail = documentSnapshot.data()!['fromEmail'] ?? '';
    read = documentSnapshot.data()!['read'] ?? false;
    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
  }
}
