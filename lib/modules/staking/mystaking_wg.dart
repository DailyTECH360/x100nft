import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/utils.dart';
import 'mystaking_ctrst.dart';
import 'mystaking_item.dart';

Widget stakingListWidget() {
  return GetX<AllStakingCtrST>(
    init: Get.put(AllStakingCtrST()),
    builder: (ctr) {
      if (ctr.uInvestlist.isNotEmpty) {
        return Column(
          children: [
            const Divider(color: Colors.white24, thickness: 1),
            Text(myStaking.toUpperCase(), style: const TextStyle(color: Colors.white)),
            const Divider(color: Colors.white24, thickness: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ctr.uInvestlist.length,
              itemBuilder: (_, index) {
                return MyStakingIteam(data: ctr.uInvestlist[index]);
              },
            ),
          ],
        );
      } else {
        return Center(child: Wg.noData());
      }
    },
  );
}
