import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/utils.dart';

import 'noti_ctrst.dart';

class ItemNoti extends StatelessWidget {
  final NoticeModel? noticeModel;
  const ItemNoti({Key? key, this.noticeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!noticeModel!.read!) {
          Get.defaultDialog(
              title: '$notify:',
              confirmTextColor: Colors.white,
              buttonColor: AppColors.primaryColor,
              textConfirm: close,
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Text('${noticeModel!.title}'.capitalizeFirst!, style: const TextStyle(fontSize: 18)),
                    _content(),
                  ],
                ),
              ),
              onConfirm: () {
                Get.back();
              });
          await NotiCtrST.to.notiRead(notiId: noticeModel!.id);
        }
      },
      child: Card(
        margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        color: noticeModel!.read! ? Colors.white60 : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Wg.timeWg(timeData: noticeModel!.timeCreated!, size: 14)),
                  Text('${noticeModel!.title}'.capitalizeFirst!, style: const TextStyle(fontSize: 18)),
                ],
              ),
              const Divider(color: Colors.black54, height: 10, thickness: 1),
              _content(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        Text(
          noticeModel!.content!.capitalizeFirst!,
          style: TextStyle(color: AppColors.primaryColor, fontStyle: FontStyle.italic),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(noticeModel!.fromName!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text(
              '(${stringDot(text: noticeModel!.fromPhone != '' ? noticeModel!.fromPhone! : noticeModel!.fromEmail!, before: 12, after: 0)})',
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ],
    );
  }
}
