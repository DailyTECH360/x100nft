import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AllStakingCtrST extends GetxController {
  static AllStakingCtrST get to => Get.find();

  final Rx<List<StakingModel>> _uInvestlist = Rx<List<StakingModel>>([]);
  List<StakingModel> get uInvestlist => _uInvestlist.value;

  // RxDouble investAmount = (UserCtr.to.userDB != null ? UserCtr.to.userDB!.wUsd!.floor().toDouble() : 0.0).obs;

  Rx<bool> seView = Rx<bool>(false);

  @override
  void onInit() {
    seView.value = false;
    _uInvestlist.bindStream(getUserStakingList(uid: UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _uInvestlist.close();
    _uInvestlist.value = <StakingModel>[];
    super.dispose();
  }

  // investCount(List<StackingModel> _list) async {
  //   int totalInvestsNum = 0;
  //   double totalInvestAmount = 0.0;
  //   if (_list.isNotEmpty) {
  //     totalInvestAmount = 0;
  //     totalInvestsNum = 0;
  //     for (var element in _list) {
  //       if (element.amount! > 0) {
  //         totalInvestsNum++;
  //         totalInvestAmount = totalInvestAmount + element.amount!;
  //       }
  //     }
  //     updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'totalInvests': totalInvestsNum});
  //   }
  // }

  Stream<List<StakingModel>> getUserStakingList({required String uid}) {
    return _firestore.collection('stakings').where('uid', isEqualTo: uid).orderBy('timeCreated', descending: true).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        List<StakingModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(StakingModel.fromDocumentSnapshot(documentSnapshot: element));
        }
        // investCount(retVal);
        return retVal;
      },
    );
  }

  deleInvest(BuildContext context, {required StakingModel data}) {
    if (UserCtr.to.userDB != null) {
      Get.defaultDialog(
          middleText: '${"Delete this investment order".tr}\n${"Are you sure?".tr}'.toUpperCase(),
          textConfirm: "Yes!".tr,
          textCancel: "No!".tr,
          confirmTextColor: Colors.white,
          onConfirm: () async {
            Get.back();

            await deleteAny(coll: 'stakings', docId: data.id!);
            showTopSnackBar(context, CustomSnackBar.success(message: '${"The investment package has been deleted".tr}: ${NumF.decimals(num: data.amount!)}'),
                additionalTopPadding: 60);
          });
    }
  }
}
