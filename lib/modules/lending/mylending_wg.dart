import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/utils.dart';
import 'mylending_ctrst.dart';
import 'mylending_item.dart';

Widget lendingListWidget() {
  return GetX<AllLendingCtrST>(
    init: Get.put(AllLendingCtrST()),
    builder: (ctr) {
      if (ctr.uInvestlist.isNotEmpty) {
        return Column(
          children: [
            const Divider(color: Colors.white24, thickness: 1),
            Text(lending.toUpperCase(), style: const TextStyle(color: Colors.white)),
            const Divider(color: Colors.white24, thickness: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ctr.uInvestlist.length,
              itemBuilder: (_, index) {
                return MyLendingIteam(data: ctr.uInvestlist[index]);
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
