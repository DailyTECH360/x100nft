import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'my_wallet.dart';
import 't_item.dart';
import 'wallet_ctrst.dart';

class WalletPage extends GetWidget<UserCtr> {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(title: Text(myWallet)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GetX<WalletCtrST>(
              init: Get.put(WalletCtrST()),
              builder: (tranCtr) {
                if (tranCtr.myTransactionList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tranCtr.myTransactionList.length,
                      itemBuilder: (_, index) {
                        return TransactionsItem(data: tranCtr.myTransactionList[index]);
                      },
                    ),
                  );
                }
                return Expanded(child: Wg.noData());
              },
            )
          ],
        ),
      ),
    );
  }
}

class WalletWidget extends StatelessWidget {
  final List wInfoList;
  const WalletWidget({Key? key, required this.wInfoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 136,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: wInfoList.length,
        itemBuilder: (context, index) => WalletCon(wInfo: wInfoList[index]),
      ),
    );
  }
}

class WalletCon extends StatelessWidget {
  final WalletInfo? wInfo;
  const WalletCon({Key? key, this.wInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<UserCtr>(
      builder: (_) {
        return Container(
          width: 290,
          margin: const EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.linearG1,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.white54, width: 1),
            // image: const DecorationImage(image: AssetImage("assets/bg/bg_black.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Image.asset(wInfo!.iconImage!, height: 40),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(NumF.decimals(num: getWalletBalance(wInfo!.wallet!)), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('${wInfo!.symbol!} ', style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 20, thickness: 1),
              wInfo!.btWg ?? Container(),
            ],
          ),
        );
      },
    );
  }
}
