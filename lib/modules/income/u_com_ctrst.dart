import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/models/com_model.dart';
import '../../data/user_ctr.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UComCtrST extends GetxController {
  final Rx<List<CommissionModel>> _uComList = Rx<List<CommissionModel>>([]);
  List<CommissionModel> get uComList => filterList(_uComList.value);

  void startGetST({required String uid}) => _uComList.bindStream(userGetComST(uid: uid));

  @override
  void onInit() {
    _uComList.bindStream(userGetComST(uid: UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _uComList.close();
    _uComList.value = <CommissionModel>[];
    super.dispose();
  }

  List<CommissionModel> filterList(List<CommissionModel> list) {
    List<CommissionModel> listNew = <CommissionModel>[];
    if (list.isNotEmpty) {
      for (CommissionModel e in list) {
        if (e.site == 'web1') {
          listNew.add(e);
        }
      }
    }
    return listNew;
  }

  Stream<List<CommissionModel>> userGetComST({required String uid}) {
    return _firestore.collection('commissions').where('uid', isEqualTo: uid).orderBy('timeCreated', descending: true).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> query,
    ) {
      List<CommissionModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(CommissionModel.fromDocumentSnapshot(documentSnapshot: element));
      }
      return retVal;
    });
  }
}
