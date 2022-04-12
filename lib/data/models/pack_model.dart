import 'package:cloud_firestore/cloud_firestore.dart';

class PackagesModel {
  String? title;
  int? number;
  int? minInvest;
  int? maxInvest;
  int? cycle;

  String? rateD;
  bool? run;
  String? textNoRun;
  Timestamp? timeRun;

  PackagesModel({
    this.title,
    this.number,
    this.minInvest,
    this.maxInvest,
    this.cycle,
    this.rateD,
    this.run,
    this.textNoRun,
    this.timeRun,
  });
  PackagesModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    title = documentSnapshot.data()!['title'] ?? '';
    number = documentSnapshot.data()!['number'] as int? ?? 0;
    minInvest = documentSnapshot.data()!['minInvest'] as int? ?? 0;
    maxInvest = documentSnapshot.data()!['maxInvest'] as int? ?? 0;
    cycle = documentSnapshot.data()!['cycle'] as int? ?? 0;
    rateD = documentSnapshot.data()!['rateD'] ?? '1';
    run = documentSnapshot.data()!['run'] ?? true;
    textNoRun = documentSnapshot.data()!['textNoRun'] as String? ?? '';
    timeRun = documentSnapshot.data()!['timeRun'] ?? Timestamp.now();
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'number': number,
        'minInvest': minInvest,
        'maxInvest': maxInvest,
        'cycle': cycle,
        'rateD': rateD,
        'run': run,
        'textNoRun': textNoRun,
        'timeRun': timeRun,
      };
}
