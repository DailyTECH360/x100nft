import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../profit_lending/profit_lend_page.dart';

class MyLendingIteam extends StatelessWidget {
  final LendingModel data;
  const MyLendingIteam({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 8),
      child: Column(
        children: [
          Card(
            color: data.status == 'stop'
                ? Colors.redAccent[100]
                : data.status == 'done'
                    ? Colors.greenAccent[100]
                    : Colors.white,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(child: Wg.timeWg(timeData: data.timeCreated!, size: 14)),
                      Visibility(
                        visible: data.status != 'stop',
                        child: ElevatedButton.icon(
                          label: Text(stop.toUpperCase()),
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () async {
                            Get.defaultDialog(
                                textConfirm: yes,
                                textCancel: no,
                                confirmTextColor: Colors.white,
                                titlePadding: const EdgeInsets.all(3),
                                contentPadding: const EdgeInsets.all(16),
                                content: Column(
                                  children: [
                                    Text(stopLending, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                    const SizedBox(height: 10),
                                    Text(sure.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                onConfirm: () async {
                                  Get.back();
                                  await updateAnyField(coll: 'lendings', docId: data.id!, data: {'status': 'stop'});
                                });
                          },
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(5),
                      //   decoration: BoxDecoration(color: AppColors.primaryColor, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(5)),
                      //   child: Text('${data.cycleDay}', style: const TextStyle(color: Colors.white)),
                      // ),
                      // const Text(' left: ', style: TextStyle(color: Colors.black)),
                      // Container(
                      //   padding: const EdgeInsets.all(5),
                      //   decoration: BoxDecoration(color: AppColors.primaryColor, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(5)),
                      //   child: Text('${data.cycleDay! - data.getDoneDay!}', style: const TextStyle(color: Colors.white)),
                      // ),
                    ],
                  ),
                  const Divider(color: Colors.black26, height: 20),
                  _packInvest(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _packInvest() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$lending ${data.symbol}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                Text('${data.rateD}%/$day', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: AppColors.primaryColor, border: Border.all(color: Colors.white30), borderRadius: BorderRadius.circular(30)),
                  child: Text(NumF.decimals(num: data.amount!), style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(width: 5),
            Wg.logoBoxCircle(pic: getLogoByWallet(data.symbol!), maxH: 40, colorBorder: Colors.black26, color: Colors.white30),
          ],
        ),
        const SizedBox(height: 5),
        Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black12, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(5)),
            ),
            Container(
              height: 8,
              width: data.getDoneDay! / data.cycleDay! * (Get.width - 32),
              constraints: const BoxConstraints(minWidth: 5),
              decoration: BoxDecoration(color: AppColors.primaryLight, border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(5)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$received: ', style: TextStyle(color: AppColors.primaryDeep)),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text('${NumF.decimals(num: data.getDoneAmount!)} ${data.symbol}', style: const TextStyle(color: Colors.white)),
            ),
            Text(' / ', style: TextStyle(color: AppColors.primaryDeep)),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text('${data.getDoneDay!.toDouble()}', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 5),
            Text(day, style: TextStyle(color: AppColors.primaryDeep)),
            const SizedBox(width: 5),
            InkWell(child: const Icon(Icons.list, color: Colors.black), onTap: () => Get.to(ProfitLendPage(uData: UserCtr.to.userDB!, id: data.id!)))
          ],
        ),
      ],
    );
  }
}
