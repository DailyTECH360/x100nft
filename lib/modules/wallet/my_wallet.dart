import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/services/wg_global/num_page.dart';
import '../../data/services/wg_global/vk_multi.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../../data/services/twofa_page.dart';
import 'withdraw_page.dart';

List walletDataList = [
  // WalletInfo(
  //   name: symbolUsdt,
  //   symbol: symbolUsdt,
  //   iconImage: 'assets/crypto/USDT_TRC.png',
  //   wallet: 'wUsd',
  //   btWg: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: const [
  //       // IconButton(
  //       //     icon: const Icon(Icons.payments, color: Colors.white),
  //       //     tooltip: "Deposit",
  //       //     onPressed: () {
  //       //       //  Get.to(const DepositPage());
  //       //     }),
  //       TransferBtWidget(symbol: 'USDT', wallet: 'wUsd'),
  //       WithdrawBtWidget(symbol: 'USDT', wallet: 'wUsd'),
  //     ],
  //   ),
  // ),
  WalletInfo(
    name: symbolUsdt,
    symbol: symbolUsdt,
    iconImage: 'assets/crypto/vnd512.png',
    wallet: 'wUsd',
    btWg: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        // IconButton(
        //     icon: const Icon(Icons.payments, color: Colors.white),
        //     tooltip: "Deposit",
        //     onPressed: () {
        //       //  Get.to(const DepositPage());
        //     }),
        TransferBtWidget(symbol: 'VND', wallet: 'wUsd'),
        WithdrawBtWidget(symbol: 'VND', wallet: 'wUsd'),
      ],
    ),
  ),
  // WalletInfo(
  //   name: symbolToken,
  //   symbol: symbolToken,
  //   iconImage: 'assets/brand/192.png',
  //   wallet: 'wCom',
  //   btWg: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       WithdrawBtWidget(symbol: symbolToken, wallet: 'wCom'),
  //     ],
  //   ),
  // ),
  // WalletInfo(
  //   name: symbolToken2,
  //   symbol: symbolToken2,
  //   iconImage: 'assets/brand/192.png',
  //   wallet: 'wProfit',
  //   btWg: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       WithdrawBtWidget(symbol: symbolToken2, wallet: 'wProfit'),
  //     ],
  //   ),
  // ),
];

class TransferBtWidget extends StatelessWidget {
  final String wallet, symbol;
  const TransferBtWidget({Key? key, required this.wallet, required this.symbol}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.send, color: Colors.white),
      tooltip: trans,
      onPressed: () {
        if (CheckSV.lockTransCheck(context, dk: !UserCtr.to.userDB!.lockTrans!)) {
          debugPrint('${getWalletBalance(wallet)}');
          debugPrint('minTransfer: ${UserCtr.to.set!.minTransfer!}');
          if (CheckSV.minCheck(context, dk: getWalletBalance(wallet) >= UserCtr.to.set!.minTransfer!, min: UserCtr.to.set!.minTransfer!)) {
            if (UserCtr.to.userDB!.set2fa != true) {
              transferForm(context, wallet: wallet, symbol: symbol);
            } else {
              verify2faForm(context, callback: () => transferForm(context, wallet: wallet, symbol: symbol));
            }
          }
        }
      },
    );
  }
}

class WithdrawBtWidget extends StatelessWidget {
  final String wallet, symbol;
  const WithdrawBtWidget({Key? key, required this.wallet, required this.symbol}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cloud_download, color: Colors.white),
      tooltip: withdraw,
      onPressed: () {
        if (CheckSV.lockWithdrawCheck(context, dk: !UserCtr.to.userDB!.lockWithdraw!)) {
          if (CheckSV.minCheck(context, dk: getWalletBalance(wallet) >= UserCtr.to.set!.minWithdraw!, min: UserCtr.to.set!.minWithdraw!)) {
            UserCtr.to.userDB!.set2fa != true ? Get.to(const WithdrawPage()) : verify2faForm(context, callback: () => Get.to(const WithdrawPage()));
          }
        }
      },
    );
  }
}

class WalletInfo {
  final String? symbol, name, iconImage;
  final String? wallet;
  final Widget? btWg;
  WalletInfo({this.symbol, this.name, this.iconImage, this.wallet, this.btWg});
}

// ------------------------------------------ TRANSFER FUNC
Future<void> transactionFunc(
  BuildContext context, {
  required double amount,
  required String wallet,
  required String symbol,
  double? fee,
  double? rate,
  String? type,
  String? addrW,
  UserModel? userFindData,
}) async {
  Loading.show(text: 'User Update...', textSub: '$notCloseApp!');
  if (type == 'Transfer') {
    // GHI VÀO USER CHỦ (- số dư ví & tạo giao dịch)
    await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: wallet, amount: -amount);
    await addTransactions(
      amount: -amount,
      fee: fee ?? 0,
      type: type!,
      wallet: wallet,
      symbol: symbol,
      mainUserDB: UserCtr.to.userDB!,
      uOtherUid: userFindData!.uid,
      uOtherName: userFindData.name,
    );
    // GHI VÀO USER ĐÍCH (+ vào số dư & tạo giao dịch)
    await saveAnyField(coll: 'users', doc: userFindData.uid!, field: wallet, amount: amount);
    await addTransactions(
      amount: amount - ((fee ?? 0) * amount),
      fee: fee ?? 0,
      type: 'Received',
      wallet: wallet,
      symbol: symbol,
      mainUserDB: userFindData,
      uOtherUid: UserCtr.to.userDB!.uid,
      uOtherName: UserCtr.to.userDB!.name,
    );
  } else if (type == 'Withdraw') {
    // GHI VÀO USER CHỦ (- số dư ví & tạo giao dịch)
    await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: wallet, amount: -amount);
    await addTransactions(
      amount: -amount,
      fee: fee ?? 0,
      rate: rate ?? 1,
      type: type!,
      wallet: wallet,
      symbol: symbol,
      status: 'pending',
      mainUserDB: UserCtr.to.userDB!,
      uOtherUid: addrW,
      uOtherName: addrW,
    );
    // await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: getJsonUserSaveAddrW(symbol: symbol, addrW: addrW!));

    Loading.hide();
  }
}

transferForm(BuildContext context, {required String wallet, required String symbol}) {
  UserModel? uDB = UserCtr.to.userDB;
  if (uDB != null) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _amountTextCtr = TextEditingController();
    final TextEditingController _toTextCtr = TextEditingController();
    Future addTextFunc(String text) async {
      _toTextCtr.text = text;
      // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
      debugPrint('Text Input: $text');
    }

    Future wAmount(BuildContext context, String text) async {
      _amountTextCtr.text = text;
      // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
      debugPrint('aWAdd: $text');
    }

    PopUp.popUpWg(context,
        wg: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(trans.toUpperCase()),
                Wg.textRowWg(title: '$symbol:', text: NumF.decimals(num: getWalletBalance(wallet))),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () => Get.to(NumPage(getText: wAmount)),
                  child: TextFormField(
                    enabled: false,
                    controller: _amountTextCtr,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.none,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      labelText: enterAmount,
                      hintText: '$min: ${UserCtr.to.set!.minTransfer}',
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                    validator: (String? value) {
                      if (value == '') {
                        return 'The field cannot be empty!';
                      }
                      if (double.parse(value!) < UserCtr.to.set!.minTransfer!) {
                        return 'Minimum amount must >= ${UserCtr.to.set!.minTransfer!}';
                      }
                      if (double.parse(value) > (uDB.wUsd!)) {
                        return 'Wallet balance is not enough!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => Get.to(VirtualkeyboardPage(getText: addTextFunc)),
                  child: SizedBox(
                    child: TextFormField(
                      controller: _toTextCtr,
                      enabled: false,
                      // keyboardType: TextInputType.text,
                      keyboardType: TextInputType.none, // Disable the default soft keybaord
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        labelText: '$findBy email, phone, refcode',
                        hintText: 'abc@abc.abc, 0988...',
                        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      validator: (String? value) {
                        if (value == '') {
                          return 'The field cannot be empty!';
                        }
                        if (value!.length < 6) {
                          return 'Refcode is not format!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: Text(trans.toUpperCase(), style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder(), elevation: 5, primary: AppColors.primaryColor),
                  onPressed: () async {
                    hideKeyboard(context);
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    if (CheckSV.internetCheck(context)) {
                      Get.back();
                      if (_toTextCtr.text == (_toTextCtr.text.isEmail ? uDB.email : uDB.refCode)) {
                        Get.defaultDialog(
                          middleText: notSelfTrans,
                          textConfirm: ok,
                          confirmTextColor: Colors.white,
                          onConfirm: () => Get.back(),
                        );
                      } else {
                        if (CheckSV.balanceCheck(context, dk: double.parse(_amountTextCtr.text) <= getWalletBalance(wallet))) {
                          //CHAY HAM:
                          Loading.show(text: 'User find...', textSub: '$notCloseApp!');
                          String type = 'Transfer';
                          UserModel? userFindData = await findFirstUser(by: _toTextCtr.text);
                          if (userFindData == null && userFindData!.uidSpon!.length < 3) {
                            Loading.hide();
                            Get.defaultDialog(
                              middleText: '$notFoundUser!',
                              textConfirm: ok,
                              confirmTextColor: Colors.white,
                              onConfirm: () => Get.back(),
                            );
                          } else {
                            Loading.hide();
                            Get.defaultDialog(
                                title: '$infoConfirm:',
                                titlePadding: const EdgeInsets.all(3),
                                contentPadding: const EdgeInsets.all(12),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('$symbol $type: ${NumF.decimals(num: double.parse(_amountTextCtr.text))} -> To:'),
                                    Text('${_toTextCtr.text}(${userFindData.name})'),
                                    const Divider(color: Colors.grey, height: 10, thickness: 1),
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
                                  await transactionFunc(
                                    context,
                                    amount: double.parse(_amountTextCtr.text),
                                    wallet: wallet,
                                    symbol: symbol,
                                    type: type,
                                    userFindData: userFindData,
                                  );
                                  Get.snackbar('$notice:', '$type done! ${_toTextCtr.text} - ${userFindData.name}',
                                      snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                                });
                          }
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
