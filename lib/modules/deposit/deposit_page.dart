import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/services/check_sv.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'dep_item.dart';
import 'deposit_ctrst.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          title: const Text('Deposit by crypto'),
          bottom: const PreferredSize(preferredSize: Size.fromHeight(35), child: TabDep()),
        ),
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: DepInfo(chain: 'BNB'),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: DepInfo(chain: 'USDT(BEP20)'),
            ),
          ],
        ),
      ),
    );
  }
}

class DepInfo extends StatelessWidget {
  final String chain;
  const DepInfo({Key? key, required this.chain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool runDepCall = false;
    return GetX<DepositCtrST>(
      init: DepositCtrST(),
      builder: (_) {
        String address = (chain == 'TRC20' ? UserCtr.to.userDB!.addrDepTrc! : UserCtr.to.userDB!.addrDepBep!);
        // String picChain = chain == 'TRC20' ? 'usdtTron_name.png' : 'binance_smart_chain.jpg';
        String addressChain = (chain == 'TRC20' ? 'addrDepTrc' : 'addrDepBep');
        _.depChainChoose.value = (chain == 'TRC20' ? 'depCallTrc' : 'depCallBep');
        if (address.length > 10) {
          if (!runDepCall) {
            runDepCall = true;
            Future.delayed(Duration.zero, () async {
              await checkDepositNew(symbol: chain, callDep: _.depChainChoose.value);
            });
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Deposit required $chain address!', style: TextStyle(color: AppColors.primaryLight)),
                const SizedBox(height: 8),
                QrImage(data: address, version: QrVersions.auto, size: 150, backgroundColor: Colors.white),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wg.textDot(text: address, style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 5),
                    InkWell(
                      child: const Icon(Icons.copy, color: Colors.white, size: 16),
                      onTap: () {
                        if (copyToClipboardHack(address)) {
                          Get.snackbar('Copy: ', address, snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                        }
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 16, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wg.textRowWg(
                        title: 'Total deposit:',
                        text: '${chain == 'BNB' ? NumF.decimals(num: UserCtr.to.userDB!.totalDepBnb!) : NumF.decimals(num: UserCtr.to.userDB!.totalDepUsdtBep20!)} $chain',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 5),
                    InkWell(
                      child: const Icon(Icons.sync, color: Colors.white54, size: 16),
                      onTap: () async {
                        if (CheckSV.internetCheck(context)) {
                          Future.delayed(Duration.zero, () async {
                            await checkDepositNew(symbol: chain, callDep: _.depChainChoose.value);
                          });
                          showTopSnackBar(context, const CustomSnackBar.success(message: 'Deposit required ReChecking...'));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                (UserCtr.to.userDB != null && address.length >= 10 && _.depDBList.isNotEmpty)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _.depDBList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DepItem(data: _.depDBList[index]);
                        },
                      )
                    : Wg.noData(),
                const SizedBox(height: 5),
                Visibility(
                  visible: (UserCtr.to.userDB != null && address.length >= 10),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        label: const Text('Deposit ReCheck'),
                        icon: const Icon(Icons.sync),
                        onPressed: () async {
                          if (CheckSV.internetCheck(context)) {
                            Future.delayed(Duration.zero, () async {
                              await checkDepositNew(symbol: chain, callDep: _.depChainChoose.value);
                            });
                            showTopSnackBar(context, const CustomSnackBar.success(message: 'Deposit required ReChecking...'));
                          }
                        },
                      ),
                      const SizedBox(height: 5),
                      const Text('If you already have a successful deposit and you still don\'t see your balance & transaction here',
                          style: TextStyle(color: Colors.orangeAccent), textAlign: TextAlign.center),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: ElevatedButton(
                child: Text('Deposit required $chain address'),
                onPressed: () async {
                  await checkAddressDep(addressChain);
                  showTopSnackBar(context, CustomSnackBar.success(message: 'Deposit required $chain address!'));
                }),
          );
        }
      },
    );
  }
}

class TabDep extends StatelessWidget {
  const TabDep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.all(5.0),
      indicatorColor: Colors.amberAccent,
      tabs: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.payments), SizedBox(width: 5), Text('BNB')]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.payments), SizedBox(width: 5), Text('USDT(BEP20)')]),
      ],
    );
  }
}
