import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'team_ctrst.dart';
import 'team_item.dart';

class TeamPage extends GetView<UserCtr> {
  const TeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userDB!.phone != null) {
        return Scaffold(
          backgroundColor: AppColors.primaryDeep,
          appBar: AppBar(title: Text(affiliate)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wg.sponWg(),
                    const Divider(color: Colors.white12, thickness: 1, height: 16),
                    refLinkWg(reLink: UserCtr.to.reLink),
                    const SizedBox(height: 5),
                    Wg.teamCountWg(),
                    const SizedBox(height: 5),
                    GetX<TeamCtrST>(
                      init: Get.put(TeamCtrST()),
                      builder: (ctr) {
                        if (ctr.teamF1List.isNotEmpty) {
                          ctr.getF1Act(ctr.teamF1List).then((value) {
                            // debugPrint('teamF1Act: $value');
                            updateUserDB(uid: controller.userDB!.uid!, data: {'teamF1Act': value});
                          });
                          // debugPrint('teamF1: ${ctr.teamF1List.length}');
                          updateUserDB(uid: controller.userDB!.uid!, data: {'teamF1': ctr.teamF1List.length});
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ctr.teamF1List.length,
                            itemBuilder: (_, index) {
                              return TeamItem(userData: ctr.teamF1List[index]);
                            },
                          );
                        } else {
                          return Wg.noData();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
