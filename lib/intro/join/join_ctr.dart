import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/user_ctr.dart';

class JoinCtr extends GetxController {
  static JoinCtr to = Get.find();

  static UserCtr toUCtr = Get.find();

  Rx<String> formView = Rx<String>(GetStorage().read('logBy') == 'phone'
      ? 'phone'
      : (GetStorage().read('logBy') == 'email')
          ? 'email'
          : 'gg');
  Rx<bool> joinByPhone = Rx<bool>(false);
  Rx<bool> joinByMail = Rx<bool>(false);

  Rx<bool> get buttonWgView => (waitEmailLink.value ? false : true).obs;
  Rx<bool> waitEmailLink = Rx<bool>(false);

  Rx<bool?> isChecked = Rx<bool?>(true);

  @override
  onInit() {
    joinByPhone.value = true;
    joinByMail.value = false;
    super.onInit();
  }
}
