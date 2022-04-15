import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/tokenprice_m.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'swap_model.dart';

class SwapCtr extends GetxController {
  static SwapCtr get to => Get.find();
  Rx<WalletInfoModel> ojFrom = Rx<WalletInfoModel>(wListFrom.first);
  Rx<WalletInfoModel> ojTo = Rx<WalletInfoModel>(wListTo.first);

  Rx<double> amountFrom = 0.0.obs;
  final TextEditingController amountFromTextCtr = TextEditingController();

  // ----------------------------------------------------------------
  Rx<double> rateBnb = 0.0.obs;
  Rx<double> rateUsdt = 0.0.obs;
  Rx<double> get rate => (ojFrom.value.symbol! == 'BNB' ? rateBnb.value : rateUsdt.value).obs;
  Rx<double> get feeSwap => (UserCtr.to.set!.feeSwap!).obs;
  Rx<double> get amountTo => ((amountFrom.value * rate.value) - ((amountFrom.value * rateBnb.value) * (feeSwap.value / 100))).obs;

  @override
  onInit() async {
    TokenPricePk pri = await getTokenPricePanecakeApi(symbol: ojTo.value.symbol!);
    rateBnb.value = pri.data!.priceBnb!;
    to.rateUsdt.value = pri.data!.priceUsd!;
    super.onInit();
  }

  swapSwitch() {
    WalletInfoModel from = ojFrom.value;
    WalletInfoModel to = ojTo.value;
    ojFrom.value = to;
    ojTo.value = from;
  }

  // final _obj = ''.obs;
  // set obj(value) => this._obj.value = value;
  // get obj => this._obj.value;

  String get type => '${ojFrom.value.symbol} swap to ${ojTo.value.symbol} (${NumF.decimals(num: rate.value)})';
  Future<void> swapSave() async {
    Loading.show(text: '$swap...', textSub: '$notCloseApp!');
    // TẠO GIAO DỊCH SWAP:

    SwapModel _swapData = SwapModel(
      amountFrom: amountFrom.value,
      amountTo: amountTo.value,
      rate: rate.value,
      fee: feeSwap.value,
      note: type,
      uid: UserCtr.to.userDB!.uid,
      name: UserCtr.to.userDB!.name,
      email: UserCtr.to.userDB!.email,
      phone: UserCtr.to.userDB!.phone,
      timeCreated: Timestamp.now(),
      t: UserCtr.to.userDB!.role! == 'T' ? true : false,
    );
    await addDocToCollDynamic(coll: 'swaps', data: _swapData.toJson());

    // Tạo gd TRỪ
    await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: ojFrom.value.wallet!, amount: -amountFrom.value);
    await addTransactions(amount: -amountFrom.value, symbol: ojFrom.value.symbol!, fee: feeSwap.value, type: 'Swaps', note: type, mainUserDB: UserCtr.to.userDB!);

    // Tạo gd CỘNG
    await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: ojTo.value.wallet!, amount: amountTo.value);
    await addTransactions(amount: amountTo.value, symbol: ojTo.value.symbol!, fee: feeSwap.value, type: 'Swaps', note: type, mainUserDB: UserCtr.to.userDB!);
    Loading.hide();
  }
}

class WalletInfoModel {
  final String? symbol, name, iconImage;
  final String? wallet;
  final double? rate;
  WalletInfoModel({this.symbol, this.name, this.iconImage, this.wallet, this.rate});
}

List<WalletInfoModel> wListFrom = [
  WalletInfoModel(
    name: getSymbolByWallet('wBnb'),
    symbol: getSymbolByWallet('wBnb'),
    iconImage: getLogoByWallet(getSymbolByWallet('wBnb')),
    wallet: 'wBnb',
  ),
  WalletInfoModel(
    name: getSymbolByWallet('wUsd'),
    symbol: getSymbolByWallet('wUsd'),
    iconImage: getLogoByWallet(getSymbolByWallet('wUsd')),
    wallet: 'wUsd',
  ),
];
List<WalletInfoModel> wListTo = [
  WalletInfoModel(
    name: getSymbolByWallet('wDot'),
    symbol: getSymbolByWallet('wDot'),
    iconImage: getLogoByWallet(getSymbolByWallet('wDot')),
    wallet: 'wDot',
  ),
  WalletInfoModel(
    name: getSymbolByWallet('wPoly'),
    symbol: getSymbolByWallet('wPoly'),
    iconImage: getLogoByWallet(getSymbolByWallet('wPoly')),
    wallet: 'wPoly',
  ),
  WalletInfoModel(
    name: getSymbolByWallet('wShiba'),
    symbol: getSymbolByWallet('wShiba'),
    iconImage: getLogoByWallet(getSymbolByWallet('wShiba')),
    wallet: 'wShiba',
  ),
  WalletInfoModel(
    name: getSymbolByWallet('wAda'),
    symbol: getSymbolByWallet('wAda'),
    iconImage: getLogoByWallet(getSymbolByWallet('wAda')),
    wallet: 'wAda',
  ),
];
