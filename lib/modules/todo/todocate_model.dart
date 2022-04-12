import 'package:cloud_firestore/cloud_firestore.dart';

class TodoCateModel {
  String? id;
  String? title;
  String? content;
  String? icon;
  String? image;
  List? paCate;
  String? uid;
  Timestamp? timeCreated;

  TodoCateModel({this.id, this.title, this.content, this.icon, this.image, this.paCate, this.uid, this.timeCreated});

  TodoCateModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    title = documentSnapshot.data()!["title"] ?? '';
    content = documentSnapshot.data()!["content"] ?? '';
    icon = documentSnapshot.data()!["icon"] ?? '';
    image = documentSnapshot.data()!["image"] ?? '';
    paCate = documentSnapshot.data()!["paCate"] ?? [];
    uid = documentSnapshot.data()!["uid"] ?? '';
    timeCreated = documentSnapshot.data()!["timeCreated"] ?? Timestamp.now();
  }
  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "icon": icon,
        "image": image,
        "paCate": paCate,
        "uid": uid,
        "timeCreated": timeCreated,
      };
}
