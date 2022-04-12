import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/models/models.dart';
import '../../data/user_ctr.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class WalletCtrST extends GetxController {
  final Rx<List<TransactionsModel>> _myTransactionList = Rx<List<TransactionsModel>>([]);
  List<TransactionsModel> get myTransactionList => _myTransactionList.value;

  final Rx<List<TransactionsModel>> _comListAll = Rx<List<TransactionsModel>>([]);
  List<TransactionsModel> get comListAll => (_comListAll.value = getComListAll());

  @override
  void onInit() {
    _myTransactionList.bindStream(getMyTransactionStream(uid: UserCtr.to.userDB!.uid!)); //stream coming from firebase
    super.onInit();
  }

  @override
  void dispose() {
    _myTransactionList.close();
    _myTransactionList.value = <TransactionsModel>[];
    super.dispose();
  }

  List<TransactionsModel> getComListAll() {
    // || e.type == 'Gen commission' || e.type == 'Small team commission' || e.type == 'Matching commission'
    List<TransactionsModel> comList = <TransactionsModel>[];
    if (myTransactionList.isNotEmpty) {
      for (var e in myTransactionList) {
        if (e.type == 'Direct commission' || e.type == 'Agent commission') {
          comList.add(e);
        }
      }
    }
    return comList;
  }

  Stream<List<TransactionsModel>> getMyTransactionStream({required String uid}) {
    return _firestore
        .collection("t")
        .where('uUid', isEqualTo: uid)
        .orderBy('timeMilis', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> query) {
      List<TransactionsModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(TransactionsModel.fromDocumentSnapshot(docSnap: element));
      }
      return retVal;
    });
  }
}
