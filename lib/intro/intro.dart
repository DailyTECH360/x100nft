import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/user_ctr.dart';
import '../data/utils.dart';
import 'home/home.dart';
import 'join/join.dart';

class Intro extends GetView<UserCtr> {
  const Intro({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<UserCtr>(
      init: Get.put(UserCtr()),
      builder: (_) {
        if (_.userAuth != null) {
          debugPrint('start auth.uid: ${stringDot(text: _.userAuth!.uid)}');
          return const Home();
          // return const HomePage();
        } else {
          return JoinPage();
        }
      },
    );
  }
}
