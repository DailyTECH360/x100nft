import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/models.dart';
import '../../../data/services/services.dart';
import '../../data/user_ctr.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AgentCtrST extends GetxController {
  static AgentCtrST get to => Get.find();

  final Rx<List<UserModel>> _agentList = Rx<List<UserModel>>([]);
  List<UserModel> get agentF1List => _agentList.value;

  final Rx<List<AgentRModel>> _agentR = Rx<List<AgentRModel>>([]);
  List<AgentRModel> get agentR => _agentR.value;

  RxString by = ''.obs;

  @override
  void onInit() {
    _agentList.bindStream(findUserAnyFieldToListStream(whereField: 'uidSpon', whereValue: UserCtr.to.userDB!.uid!));
    _agentR.bindStream(getAgentList(uid: UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _agentList.close();
    _agentList.value = <UserModel>[];
    _agentR.close();
    _agentR.value = <AgentRModel>[];
    super.dispose();
  }

  List<UserModel> agentF1ListSort() {
    List<UserModel> _new = _agentList.value;
    _new.sort((a, b) => b.comAgent!.compareTo(a.comAgent!));
    updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'comAgentF1Max': _new.first.comAgent});
    // debugPrint('first: ${_new.first.comAgent}');
    // debugPrint('last: ${_new.last.comAgent}');
    return _new;
  }

  Stream<List<AgentRModel>> getAgentList({required String uid}) {
    return _firestore.collection('agents').where('uid', isEqualTo: uid).orderBy('timestamp', descending: true).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        List<AgentRModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(AgentRModel.fromDocumentSnapshot(documentSnapshot: element));
        }
        return retVal;
      },
    );
  }
}
