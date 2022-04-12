import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/utils.dart';

import 'noti_ctrst.dart';
import 'noti_item.dart';

class NotiPage extends StatelessWidget {
  const NotiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryDeep,
        appBar: AppBar(title: Text(myNotify)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<NotiCtrST>(
              init: NotiCtrST(),
              builder: (notiCtrST) {
                if (notiCtrST.listNoti.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: notiCtrST.listNoti.length,
                      itemBuilder: (_, index) {
                        return ItemNoti(noticeModel: notiCtrST.listNoti[index]);
                      },
                    ),
                  );
                }
                return Center(child: Wg.noData());
              },
            ),
          ],
        ));
  }
}
