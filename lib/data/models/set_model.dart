import 'package:cloud_firestore/cloud_firestore.dart';

class SetModel {
  double? startPackAmount;
  double? minInvest;
  double? minBuyByUsd;
  double? minTransfer;
  double? minWithdraw;
  double? maxBuyPn;
  double? maxBuy1;
  int? maxAgent;

  double? feeSwap;
  double? feeTrans;
  double? feeWithdraw;

  double? lendingProfitDay;

  double? priceToken;
  double? priceTokenOld;
  double? pricePnDown;

  int? totalInvests;
  double? totalInvestsAmount;

  int? totalInvestsRun;
  double? totalInvestsAmountRun;

  int? totalPro;
  double? totalProAmount;

  int? totalWithdrawUSDNum;
  double? totalWithdrawUSD;
  int? totalWithdrawTokenNum;
  double? totalWithdrawToken;

  double? totalUsers;
  double? totalUsersDep;
  double? totalVolumeMe;

  int? totalCom;
  double? totalComAmount;

  double? totalTokenAir;

  double? totalBuy;
  double? totalSellFund;
  int? roundNum;
  int? phanTramLine;
  bool? sellOpen;
  bool? convertOpen;

  String? masterPayPK;
  String? masterGetAddress;

  String? vNew;
  Timestamp? deadline;

  SetModel({
    this.startPackAmount,
    this.minInvest,
    this.minBuyByUsd,
    this.minTransfer,
    this.minWithdraw,
    this.maxBuyPn,
    this.maxBuy1,
    this.maxAgent,
    this.feeSwap,
    this.feeTrans,
    this.feeWithdraw,
    this.lendingProfitDay,
    this.priceToken,
    this.priceTokenOld,
    this.pricePnDown,
    this.totalInvests,
    this.totalInvestsAmount,
    this.totalInvestsRun,
    this.totalInvestsAmountRun,
    this.totalPro,
    this.totalProAmount,
    this.totalWithdrawUSDNum,
    this.totalWithdrawUSD,
    this.totalWithdrawTokenNum,
    this.totalWithdrawToken,
    this.totalUsers,
    this.totalUsersDep,
    this.totalVolumeMe,
    this.totalCom,
    this.totalComAmount,
    this.totalTokenAir,
    this.totalBuy,
    this.totalSellFund,
    this.roundNum,
    this.phanTramLine,
    this.sellOpen,
    this.convertOpen,
    this.masterPayPK,
    this.masterGetAddress,
    this.vNew,
    this.deadline,
  });

  SetModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    vNew = documentSnapshot.data()!['vNew'] ?? '1.0.0+1';
    startPackAmount = documentSnapshot.data()!['startPackAmount'] ?? 0;
    minInvest = documentSnapshot.data()!['minInvest'] ?? 0;
    minBuyByUsd = documentSnapshot.data()!['minBuyByUsd'] ?? 0;
    minTransfer = documentSnapshot.data()!['minTransfer'] ?? 0;
    minWithdraw = documentSnapshot.data()!['minWithdraw'] ?? 0;
    maxBuyPn = documentSnapshot.data()!['maxBuyPn'] ?? 0;
    maxBuy1 = documentSnapshot.data()!['maxBuy1'] ?? 0;
    maxAgent = documentSnapshot.data()!['maxAgent'] ?? 0;

    feeSwap = documentSnapshot.data()!['feeSwap'] ?? 0;
    feeTrans = documentSnapshot.data()!['feeTrans'] ?? 0;
    feeWithdraw = documentSnapshot.data()!['feeWithdraw'] ?? 0;

    lendingProfitDay = documentSnapshot.data()!['lendingProfitDay'] ?? 0;

    priceToken = documentSnapshot.data()!['priceToken'] ?? 0.00006;
    priceTokenOld = documentSnapshot.data()!['priceTokenOld'] ?? 0;
    pricePnDown = documentSnapshot.data()!['pricePnDown'] ?? 0;

    totalInvests = documentSnapshot.data()!['totalInvests'] ?? 0;
    totalInvestsRun = documentSnapshot.data()!['totalInvestsRun'] ?? 0;
    totalInvestsAmount = documentSnapshot.data()!['totalInvestsAmount'] ?? 0;
    totalInvestsAmountRun = documentSnapshot.data()!['totalInvestsAmountRun'] ?? 0;

    totalPro = documentSnapshot.data()!['totalPro'] ?? 0;
    totalProAmount = documentSnapshot.data()!['totalProAmount'] ?? 0;

    totalCom = documentSnapshot.data()!['totalCom'] ?? 0;
    totalComAmount = documentSnapshot.data()!['totalComAmount'] ?? 0;

    totalWithdrawUSDNum = documentSnapshot.data()!['totalWithdrawUSDNum'] ?? 0;
    totalWithdrawUSD = documentSnapshot.data()!['totalWithdrawUSD'] ?? 0;
    totalWithdrawTokenNum = documentSnapshot.data()!['totalWithdrawTokenNum'] ?? 0;
    totalWithdrawToken = documentSnapshot.data()!['totalWithdrawToken'] ?? 0;

    totalUsers = documentSnapshot.data()!['totalUsers'] ?? 0;
    totalUsersDep = documentSnapshot.data()!['totalUsersDep'] ?? 0;

    totalVolumeMe = documentSnapshot.data()!['totalVolumeMe'] ?? 0;
    totalTokenAir = documentSnapshot.data()!['totalTokenAir'] ?? 0;

    totalBuy = documentSnapshot.data()!['totalBuy'] ?? 0;
    totalSellFund = documentSnapshot.data()!['totalSellFund'] ?? 0;
    roundNum = documentSnapshot.data()!['roundNum'] ?? 0;
    phanTramLine = documentSnapshot.data()!['phanTramLine'] ?? 0;
    sellOpen = documentSnapshot.data()!['sellOpen'] ?? false;
    convertOpen = documentSnapshot.data()!['convertOpen'] ?? false;

    masterPayPK = documentSnapshot.data()!['masterPayPK'] ?? '';
    masterGetAddress = documentSnapshot.data()!['masterGetAddress'] ?? '';

    deadline = documentSnapshot.data()!['deadline'] ?? Timestamp.now();
  }

  Map<String, dynamic> toJson() => {
        'maxAgent': maxAgent,
        'minInvest': minInvest,
        'minTransfer': minTransfer,
        'minWithdraw': minWithdraw,
        'feeTrans': feeTrans,
        'feeWithdraw': feeWithdraw,
        'priceToken': priceToken,
        'priceTokenOld': priceTokenOld,
        'vNew': vNew,
      };
}
