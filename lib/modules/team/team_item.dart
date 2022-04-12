import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/utils.dart';

import 'team_ctrst.dart';
import 'teamnext2_page.dart';
import 'teamnext_page.dart';

class TeamItem extends StatelessWidget {
  final UserModel userData;
  const TeamItem({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _buildListItem(context, userData),
      onTap: () async {
        await findUserAnyFieldToList(whereField: 'uidSpon', whereValue: userData.uid!).then((userList) async {
          TeamCtrST.to.getF1Act(userList).then((value) async {
            // debugPrint('teamF1Act: $value');
            await updateUserDB(uid: userData.uid!, data: {'teamF1Act': value});
          });
          // debugPrint('teamF1: ${ctr.teamF1List.length}');
          await updateUserDB(uid: userData.uid!, data: {'teamF1': userList.length});
          if (userList.isNotEmpty) {
            if (Get.arguments == 'A') {
              Get.to(TeamNexPage2(teamList: userList, userChoose: userData), arguments: 'B');
            } else {
              Get.to(TeamNexPage(teamList: userList, userChoose: userData), arguments: 'A');
            }
          } else {
            Get.defaultDialog(middleText: 'Next children is empty!', textConfirm: ok, confirmTextColor: AppColors.primaryDeep, onConfirm: () => Get.back());
          }
        });
      },
    );
  }
}

Widget _buildListItem(BuildContext context, UserModel data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.white12, border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: data.comAgent! > 0 ? Colors.green : Colors.white24,
              child: data.comAgent! > 0
                  ? Text('${data.comAgent}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))
                  : const Icon(Icons.person, size: 35, color: Colors.white),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wg.textDot(text: data.name!, before: 5, after: 5, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Wg.textDot(text: data.phone! != '' ? data.phone! : data.email!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  Row(
                    children: [
                      const Text('Join time: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(TimeF.dateToSt(date: data.timeCreated!.toDate()), style: const TextStyle(color: Colors.white60, fontSize: 13), overflow: TextOverflow.clip),
                    ],
                  ),
                  Row(
                    children: [
                      Wg.textRowWg(title: 'F1:', text: '${data.teamF1}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 5),
                      Wg.textRowWg(title: 'Total:', text: '${data.teamGen}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wg.textRowWg(title: 'W:', text: NumF.decimals(num: data.wUsd ?? 0), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'V:', text: NumF.decimals(num: data.volumeMe!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'Pro:', text: NumF.decimals(num: data.wProfitTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'Com:', text: NumF.decimals(num: data.wComTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
