import 'package:get/get.dart';
import '../../intro/join/join_ctr.dart';

import '../../modules/lending/mylending_ctrst.dart';
import '../../modules/staking/mystaking_ctrst.dart';
import '../user_ctr.dart';

class BindingCtr extends Bindings {
  @override
  void dependencies() {
    Get.put(JoinCtr());
    Get.put(UserCtr());
    Get.lazyPut(() => AllLendingCtrST());
    Get.lazyPut(() => AllStakingCtrST());
  }
}
