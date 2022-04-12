import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../profit_lending/profit_ctrst.dart';
import '../profit_lending/profit_item.dart';
import 'com_item.dart';
import 'u_com_ctrst.dart';

class IncomePage extends GetWidget<UserCtr> {
  const IncomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(centerTitle: false, title: Text(myIncome)),
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (Responsive.isDesktop(context) || Responsive.isTablet(context))
                    ? Row(
                        children: [
                          Expanded(
                            child: Wg.incomeWallet(
                              nameWallet: commission,
                              userCtr: controller,
                              icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 45),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Wg.incomeProWallet(
                              nameWallet: profit,
                              userCtr: controller,
                              balance: controller.userDB!.wProfit!,
                              total: controller.userDB!.wProfitTotal!,
                              icon: const Icon(Icons.auto_graph, color: Colors.white, size: 45),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Wg.incomeWallet(
                            nameWallet: commission,
                            userCtr: controller,
                            icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 45),
                          ),
                          const SizedBox(height: 10),
                          Wg.incomeProWallet(
                            nameWallet: profit,
                            userCtr: controller,
                            balance: controller.userDB!.wProfit!,
                            total: controller.userDB!.wProfitTotal!,
                            icon: const Icon(Icons.auto_graph, color: Colors.white, size: 45),
                          ),
                        ],
                      ),
                Visibility(
                    visible: (controller.walletChoose.value == commission),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.change_circle, color: Colors.white),
                            label: Text(convert2w, style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                            onPressed: () {
                              if (CheckSV.convertOpenCheck(context)) {
                                convertCOM(context);
                              }
                            },
                          ),
                          // const SizedBox(width: 5),
                          // ElevatedButton.icon(
                          //   icon: const Icon(Icons.change_circle, color: Colors.white),
                          //   label: Text('50%$symbolToken - 50%$symbolToken2',
                          //       style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                          //   onPressed: () {
                          //     convertProfit(context, mainUserDB: controller.userDB!, tyle: 50);
                          //   },
                          // ),
                        ],
                      ),
                    )),
                const Divider(color: Colors.white24, height: 16, thickness: 1),
                (controller.walletChoose.value != commission)
                    ? GetX<ProfitLendingCtrST>(
                        init: Get.put(ProfitLendingCtrST()),
                        builder: (ctr) {
                          if (ctr.profitList.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: ctr.profitList.length,
                                itemBuilder: (_, index) {
                                  return ProfitLendingItem(data: ctr.profitList[index]);
                                },
                              ),
                            );
                          }
                          return Expanded(child: Wg.noData());
                        },
                      )
                    : GetX<UComCtrST>(
                        init: Get.put(UComCtrST()),
                        builder: (ctr) {
                          if (ctr.uComList.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: ctr.uComList.length,
                                itemBuilder: (_, index) {
                                  return ComItem(data: ctr.uComList[index]);
                                },
                              ),
                            );
                          } else {
                            return Expanded(child: Wg.noData());
                          }
                        },
                      )
              ],
            ),
          );
        }));
  }
}
