import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/wg_global/wallet_wg.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'mylending_ctrst.dart';
import 'mylending_item.dart';

class LendingPage extends StatelessWidget {
  const LendingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AllLendingCtrST>(
        init: Get.put(AllLendingCtrST()),
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Text(myLending),
                actions: [
                  _.seView.value == false
                      ? ElevatedButton.icon(
                          label: Text(lending.toUpperCase()),
                          icon: const Icon(Icons.add_chart, color: Colors.white),
                          style: ElevatedButton.styleFrom(primary: AppColors.primaryLight, padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
                          onPressed: () => _.seView.value = true,
                        )
                      : IconButton(icon: const Icon(Icons.close, color: Colors.orange), onPressed: () => _.seView.value = false),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          (UserCtr.to.userDB != null && UserCtr.to.set != null && _.seView.value == true)
                              ? Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: WalletWg(),
                                    ),
                                    Visibility(visible: (UserCtr.to.walletChoose.value! == 'wBnb' || UserCtr.to.walletChoose.value! == 'wUsd'), child: lendingAdd(context)),
                                  ],
                                )
                              : Container(),
                          Text('#: ${_.uInvestlist.length}', style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _.uInvestlist.length,
                            itemBuilder: (c, index) {
                              return MyLendingIteam(data: _.uInvestlist[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
