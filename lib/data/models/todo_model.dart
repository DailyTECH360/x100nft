import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? creator;
  String? id;
  String? title;
  String? content;
  String? icon;

  double? process;
  int? priority;
  // DocumentSnapshot<Object>? roles;
  Object? roles;
  List? teamWork;
  List? paCate;
  List? paTodo;

  double? timeWorkTotal;
  Timestamp? timeStart;
  Timestamp? timeEnd;
  int? timeLeft;
  Timestamp? timeCreated;

  TodoModel({
    this.id,
    this.creator,
    this.title,
    this.content,
    this.icon,
    this.process,
    this.priority,
    this.roles,
    this.teamWork,
    this.paCate,
    this.paTodo,
    this.timeLeft,
    this.timeStart,
    this.timeEnd,
    this.timeCreated,
  });

  TodoModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    creator = documentSnapshot.data()!["creator"] ?? '';
    title = documentSnapshot.data()!["title"] ?? '';
    content = documentSnapshot.data()!["content"] ?? '';
    icon = documentSnapshot.data()!["icon"] ?? '';

    process = documentSnapshot.data()!["process"] ?? 0;
    priority = documentSnapshot.data()!["priority"] ?? 0;
    roles = documentSnapshot.data()!['roles'] ?? {};
    teamWork = documentSnapshot.data()!["teamWork"] ?? [];
    paCate = documentSnapshot.data()!["paCate"] ?? [];
    paTodo = documentSnapshot.data()!["paTodo"] ?? [];

    timeStart = documentSnapshot.data()!["timeStart"];
    timeEnd = documentSnapshot.data()!["timeEnd"];
    timeLeft = documentSnapshot.data()!["timeLeft"] ?? 0;
    timeCreated = documentSnapshot.data()!["timeCreated"] ?? Timestamp.now();
  }
  Map<String, dynamic> toJson() => {
        "creator": creator,
        "title": title,
        "content": content,
        "icon": icon,
        "process": process,
        "priority": priority,
        "roles": roles,
        "teamWork": teamWork,
        "paCate": paCate,
        "paTodo": paTodo,
        "timeStart": timeStart,
        "timeEnd": timeEnd,
        "timeLeft": timeLeft,
        "timeCreated": timeCreated,
      };
}
