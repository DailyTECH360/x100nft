import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/models.dart';
import '../user_ctr.dart';
import '../utils.dart';
import 'services.dart';

double svsPrice = 0;
double getE99({required double amount, required double price}) => (amount / price);

Future<void> convertCOM(BuildContext context) {
  double amountConvert = UserCtr.to.userDB!.wCom!;
  if (amountConvert > 0) {
    return Get.defaultDialog(
      middleText: '$convert $symbolUsdt $amountConvert(100%) to wallet!\n$sure',
      textCancel: no,
      textConfirm: yes,
      confirmTextColor: Colors.white,
      cancelTextColor: AppColors.primaryDeep,
      buttonColor: AppColors.primaryColor,
      onConfirm: () async {
        Get.back();
        await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'wCom': 0});
        await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: 'wUsd', amount: amountConvert);

        await addHisCommissions(amount: -amountConvert, uData: UserCtr.to.userDB!, type: 'Convert to wallet');
        await addTransactions(amount: amountConvert, type: 'Convert', note: 'Convert from commission', mainUserDB: UserCtr.to.userDB!);

        showTopSnackBar(context, const CustomSnackBar.success(message: 'Convert is DONE!'), additionalTopPadding: 250, onTap: () => Get.back());
      },
    );
  } else {
    return Get.defaultDialog(
      middleText: 'Balance need > 0!',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}

Future<void> convertCom5050(context, {required UserModel mainUserDB, required String tokenName}) async {
  double amount50 = mainUserDB.wCom! * 50 / 100;
  if (CheckSV.balanceCheck(context, dk: mainUserDB.wCom! > 0)) {
    Get.defaultDialog(
        title: 'Convert commission',
        textCancel: no,
        textConfirm: yes,
        confirmTextColor: Colors.white,
        content: Column(
          children: [
            Text('$symbolUsdt ${NumF.decimals(num: amount50)}(50%) to Main wallet'),
            Text('$symbolUsdt ${NumF.decimals(num: amount50)}(50%) to $tokenName wallet'),
            const SizedBox(height: 8),
            const Text('Are you sure?', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        onConfirm: () async {
          Get.back();
          Loading.show(text: 'Convert...', textSub: '$notCloseApp!');
          // Clear wallet, add His Com:
          await updateUserDB(uid: mainUserDB.uid!, data: {'wCom': 0});
          await addHisCommissions(amount: -mainUserDB.wCom!, uData: UserCtr.to.userDB!, type: 'Convert to wallet');

          await saveAnyField(coll: 'users', doc: mainUserDB.uid!, field: 'wUsd', amount: amount50);
          await addTransactions(amount: amount50, type: 'Convert', note: 'From 50%/commission convert', mainUserDB: mainUserDB);

          await saveAnyField(coll: 'users', doc: mainUserDB.uid!, field: 'wTokenE99', amount: amount50);
          await addTransactions(
            amount: amount50,
            symbol: 'E99',
            wallet: 'wTokenE99',
            type: 'Convert',
            note: 'From 50%/commission convert',
            mainUserDB: mainUserDB,
          );
          await saveAnyField(coll: 'admin', doc: 'out', field: 'comConvert', amount: mainUserDB.wCom!);

          Loading.hide();
          showTopSnackBar(context, const CustomSnackBar.success(message: 'Convert is DONE!'), additionalTopPadding: 100, onTap: () => Get.back());
        });
  }
}
