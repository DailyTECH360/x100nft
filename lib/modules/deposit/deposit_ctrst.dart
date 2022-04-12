import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';

// ignore_for_file: avoid_print
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DepositCtrST extends GetxController {
  final Rx<List<DepModel>> _depDBList = Rx<List<DepModel>>([]);
  List<DepModel> get depDBList => _depDBList.value;
  Rx<String> depChainChoose = ''.obs;

  @override
  void onInit() {
    _depDBList.bindStream(getMyDepositStream(uid: UserCtr.to.userAuth!.uid));
    super.onInit();
  }

  @override
  void dispose() {
    _depDBList.close();
    _depDBList.value = <DepModel>[];
    super.dispose();
  }

  // GET STREAM Deposit:
  Stream<List<DepModel>> getMyDepositStream({required String uid}) {
    return _firestore.collection("deposits").where('uidClient', isEqualTo: uid).orderBy('timestamp', descending: true).snapshots().map((QuerySnapshot<Map<String, dynamic>> query) {
      List<DepModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(DepModel.fromDocumentSnapshot(docSnap: element));
      }
      return retVal;
    });
  }
}

Future<void> checkAddressDep(String add) async {
  String address = (add == 'addrDepTrc') ? UserCtr.to.userDB!.addrDepTrc! : UserCtr.to.userDB!.addrDepBep!;
  if (address.length < 10) {
    await updateUserDB(uid: UserCtr.to.userAuth!.uid, data: {add: nanoid(5).toString()});
  }
}

Future<void> checkDepositNew({required String callDep, required String symbol}) async {
  String address = ((callDep == 'depCallTrc') ? UserCtr.to.userDB!.addrDepTrc! : UserCtr.to.userDB!.addrDepBep!);
  if (address.length > 10 && callDep != '') {
    await updateUserDB(uid: UserCtr.to.userAuth!.uid, data: {callDep: '${symbol}_${nanoid(5).toString()}'});
  }
}
