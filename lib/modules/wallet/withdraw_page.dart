import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x100nft/modules/wallet/wallet_page.dart';
import '../../data/models/tokenprice_m.dart';
import '../../data/services/services.dart';
import '../../data/services/wg_global/num_page.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'my_wallet.dart';

class WithdrawPage extends GetView<UserCtr> {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCtr.to.withdrawAmount.value = UserCtr.to.set!.minWithdraw!;
    return Obx(() => Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(title: Text(withdraw)),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wg.textRowWg(title: '$symbolUsdt Balance:', text: NumF.decimals(num: getWalletBalance(controller.walletChoose.value!))),
                      const SizedBox(height: 5),
                      Visibility(
                          visible: UserCtr.to.set!.feeWithdraw! > 0,
                          child: Wg.textRowWg(title: 'Fee', text: '${UserCtr.to.set!.feeWithdraw! * 100}%', style: const TextStyle(color: Colors.orange, fontSize: 12))),
                      const SizedBox(height: 5),
                      InkWell(
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white10, border: Border.all(color: Colors.white70), borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Withdraw amount: ', style: TextStyle(color: Colors.white)),
                                Text('${NumF.decimals(num: UserCtr.to.withdrawAmount.value)} ${getSymbolByWallet(controller.walletChoose.value!)}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            )),
                        onTap: () => Get.to(NumPage(
                            getText: wAmount,
                            initText: '${UserCtr.to.set!.minWithdraw!}',
                            min: UserCtr.to.set!.minWithdraw!,
                            max: getWalletBalance(controller.walletChoose.value!))),
                      ),
                      const SizedBox(height: 12),
                      const BankWidget(),
                      const SizedBox(height: 5),
                      const Text('Check your receiving account carefully,\nit must be your own receiving account & Make sure the required standard',
                          style: TextStyle(color: Colors.orange, fontSize: 12), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: controller.userDB != null && controller.userDB!.bank!.isNotEmpty,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_download, color: Colors.white),
                          label: Text(withdraw.toUpperCase(), style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), elevation: 5, primary: AppColors.primaryColor),
                          onPressed: () async {
                            //CHAY HAM:
                            if (CheckSV.wBankCheck(context, dk: controller.wBankChoose.value != '')) {
                              if (CheckSV.balanceCheck(context, dk: UserCtr.to.withdrawAmount.value <= getWalletBalance(controller.walletChoose.value!))) {
                                if (CheckSV.minCheck(context,
                                    dk: UserCtr.to.withdrawAmount.value > 0 && UserCtr.to.withdrawAmount.value >= UserCtr.to.set!.minWithdraw!,
                                    min: UserCtr.to.set!.minWithdraw!)) {
                                  Get.defaultDialog(
                                      title: infoConfirm,
                                      titlePadding: const EdgeInsets.all(3),
                                      contentPadding: const EdgeInsets.all(12),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(withdraw, style: const TextStyle(color: Colors.black), textAlign: TextAlign.center),
                                          Text('${NumF.decimals(num: UserCtr.to.withdrawAmount.value)} ${getSymbolByWallet(controller.walletChoose.value!)}',
                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text('Received by:\n${controller.wBankChoose.value.toString().split('_').first}: ',
                                              style: const TextStyle(color: Colors.black), textAlign: TextAlign.center),
                                          Text(controller.wBankChoose.value.toString().split('_').last,
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                          const Divider(color: Colors.grey, height: 10, thickness: 1),
                                          const Text('Check your receiving account carefully,\nit must be your own receiving account & Make sure the required standard',
                                              style: TextStyle(color: Colors.orange, fontSize: 12), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3),
                                          Text(sure, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      confirmTextColor: Colors.white,
                                      textConfirm: confirm,
                                      textCancel: no,
                                      cancelTextColor: AppColors.primaryColor,
                                      buttonColor: AppColors.primaryColor,
                                      onConfirm: () async {
                                        Get.back();
                                        TokenPricePk pri = await getTokenPricePanecakeApi(symbol: getSymbolByWallet(UserCtr.to.walletChoose.value!));
                                        double _bnbPrice = 0;
                                        if (getSymbolByWallet(UserCtr.to.walletChoose.value!) == 'BNB') {
                                          _bnbPrice = await getBnbPriceApi();
                                        }
                                        await transactionFunc(
                                          context,
                                          type: 'Withdraw',
                                          fee: UserCtr.to.set!.feeWithdraw,
                                          rate: (getSymbolByWallet(UserCtr.to.walletChoose.value!) == 'BNB') ? _bnbPrice : pri.data!.priceUsd!,
                                          amount: UserCtr.to.withdrawAmount.value,
                                          wallet: controller.walletChoose.value!,
                                          symbol: getSymbolByWallet(controller.walletChoose.value!),
                                          addrW: controller.wBankChoose.value,
                                        ).then((value) => Get.to(const WalletPage()));
                                        Get.back();
                                        showTopSnackBar(context, const CustomSnackBar.success(message: 'Withdrawal request sent!'),
                                            additionalTopPadding: 60, onTap: () => Get.back());
                                      });
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Future wAmount(BuildContext context, String text) async {
  // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
  UserCtr.to.withdrawAmount.value = double.parse((text == '') ? '0' : text);
  // debugPrint('aWAdd: $text');
}
