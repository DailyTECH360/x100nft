import 'package:get/get.dart';

import '../../../data/models/models.dart';
import '../../../data/services/services.dart';
import '../../data/user_ctr.dart';

class TeamCtrST extends GetxController {
  static TeamCtrST get to => Get.find();

  final Rx<List<UserModel>> _teamF1List = Rx<List<UserModel>>([]);
  List<UserModel> get teamF1List => _teamF1List.value;

  @override
  void onInit() {
    _teamF1List.bindStream(findUserAnyFieldToListStream(whereField: 'uidSpon', whereValue: UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _teamF1List.close();
    _teamF1List.value = <UserModel>[];
    super.dispose();
  }

  Future<int> getF1Act(List<UserModel> list) async {
    int f1ActNum = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        if (element.volumeMe! > 0) {
          f1ActNum = f1ActNum + 1;
        }
      }
    }
    return f1ActNum;
  }
}
