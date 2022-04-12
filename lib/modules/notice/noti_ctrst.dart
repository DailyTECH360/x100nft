import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/user_ctr.dart';
import '../../data/models/models.dart';
import '../../data/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class NotiCtrST extends GetxController {
  static NotiCtrST get to => Get.find();
  final Rx<List<NoticeModel>> _listNoti = Rx<List<NoticeModel>>([]);
  List<NoticeModel> get listNoti => _listNoti.value;

  final Rx<List<NoticeModel>> _listNotiUnread = Rx<List<NoticeModel>>([]);
  List<NoticeModel> get listNotiUnread => _listNotiUnread.value;

  // RxInt countNotiUnread = 0.obs;

  @override
  void onInit() {
    _listNoti.bindStream(getListNoti(uid: UserCtr.to.userAuth!.uid));
    _listNotiUnread.bindStream(getListNotiUnRead(uid: UserCtr.to.userAuth!.uid));
    super.onInit();
  }

  @override
  void dispose() {
    _listNoti.close();
    _listNoti.value = <NoticeModel>[];
    _listNotiUnread.close();
    _listNotiUnread.value = <NoticeModel>[];
    super.dispose();
  }

  Stream<List<NoticeModel>> getListNoti({required String uid}) {
    return _firestore.collection('notices').where('uid', isEqualTo: uid).orderBy('timeCreated', descending: true).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        List<NoticeModel> retVal = <NoticeModel>[];
        for (var element in query.docs) {
          retVal.add(NoticeModel.fromDocumentSnapshot(documentSnapshot: element));
        }
        return retVal;
      },
    );
  }

  Stream<List<NoticeModel>> getListNotiUnRead({required String uid}) {
    return _firestore.collection('notices').where('uid', isEqualTo: uid).where('read', isEqualTo: false).orderBy('timeCreated', descending: true).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        List<NoticeModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(NoticeModel.fromDocumentSnapshot(documentSnapshot: element));
        }
        return retVal;
      },
    );
  }

  // countUnread() {
  //   countNotiUnread.value = 0;
  //   if (_listNoti.value.isNotEmpty) {
  //     for (var element in _listNoti.value) {
  //       if (!element.read!) {
  //         countNotiUnread.value++;
  //       }
  //     }
  //   }
  // }

  Future<void> notiRead({String? notiId}) async {
    DocumentReference notiRef = _firestore.collection('notices').doc(notiId);
    // ignore: avoid_print
    await notiRef.set({'read': true}, SetOptions(merge: true)).catchError((error) => debugPrint('$noticeRead: $error'));
  }
}
