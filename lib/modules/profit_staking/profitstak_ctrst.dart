import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfitStakCtrST extends GetxController {
  static ProfitStakCtrST get to => Get.find();
  final Rx<List<ProfitStakModel>> _profitList = Rx<List<ProfitStakModel>>([]);
  List<ProfitStakModel> get profitList => _profitList.value;

  final Rx<List<ProfitStakModel>> _profitByIdList = Rx<List<ProfitStakModel>>([]);
  List<ProfitStakModel> get profitByIdList => _profitByIdList.value;

  void startGetST({required String uid, required String id}) => _profitByIdList.bindStream(profitByIdListStream(uid, id));

  // List<ProfitStakModel> profitByIdList({required String id}) => profitList.where((e) => e.investId == id).toList().obs;

  RxString by = 'd'.obs;

  RxString byDk(ProfitStakModel element) {
    if (by.value == 'd') {
      return DateTime(element.timeCreated!.toDate().year, element.timeCreated!.toDate().month, element.timeCreated!.toDate().day).toString().obs;
    } else if (by.value == 'w') {
      return weekOfYear(element.timeCreated!.toDate()).toString().obs;
    } else {
      return DateTime(element.timeCreated!.toDate().year, element.timeCreated!.toDate().month, element.timeCreated!.toDate().day).toString().obs;
    }
  }

  RxString toTextByFilter(ProfitStakModel element) {
    if (by.value == 'd') {
      return TimeF.dateToSt(date: element.timeCreated!.toDate()).obs;
    } else if (by.value == 'w') {
      return 'Week: ${weekOfYear(element.timeCreated!.toDate())}'.obs;
    } else {
      return TimeF.dateToSt(date: element.timeCreated!.toDate()).obs;
    }
  }

  sumBy({required List<ProfitStakModel> list, required ProfitStakModel by}) {
    double total = 0;
    Map<String, dynamic> sumMap = {};
    List<ProfitStakModel> listNew = list.where((e) => byDk(e).value.contains(byDk(by).value)).toList();
    for (var e in listNew) {
      if (e.profitDay! > 0) total += e.profitDay!;
    }
    sumMap['total'] = listNew.length;
    sumMap['amount'] = total;
    // debugPrint('List N: ${listNew.length} - amount: ${sumMap['amount']}');
    return sumMap;
  }

  sumAll({required List<ProfitStakModel> list}) {
    double total = 0;
    Map<String, dynamic> sumMap = {};
    for (var e in list) {
      if (e.profitDay! > 0) total += e.profitDay!;
    }
    sumMap['total'] = list.length;
    sumMap['amount'] = total;
    // debugPrint('List N: ${listNew.length} - amount: ${sumMap['amount']}');
    return sumMap;
  }

  @override
  void onInit() {
    _profitList.bindStream(getMyProfitStream(UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _profitList.close();
    _profitList.value = <ProfitStakModel>[];
    super.dispose();
  }

  double reTotalProfit() {
    double totalBonus = 0;
    for (var element in profitList) {
      if (element.profitDay! > 0) {
        totalBonus = totalBonus + element.profitDay!;
      }
    }
    return totalBonus;
  }

  double reBalanceProfit() {
    double balanceBonus = 0;
    for (var element in profitList) {
      balanceBonus = balanceBonus + element.profitDay!;
    }
    return balanceBonus;
  }

  Stream<List<ProfitStakModel>> getMyProfitStream(String uid) {
    return _firestore.collection('profitStak').where('uid', isEqualTo: uid).orderBy('timeCreated', descending: true).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> query,
    ) {
      List<ProfitStakModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(ProfitStakModel.fromDocumentSnapshot(documentSnapshot: element));
      }
      return retVal;
    });
  }

  Stream<List<ProfitStakModel>> profitByIdListStream(String uid, String id) {
    return _firestore.collection('profitStak').where('uid', isEqualTo: uid).where('stakId', isEqualTo: id).orderBy('timeCreated', descending: true).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> query,
    ) {
      List<ProfitStakModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(ProfitStakModel.fromDocumentSnapshot(documentSnapshot: element));
      }
      return retVal;
    });
  }
}
