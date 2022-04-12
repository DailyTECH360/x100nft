import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String? ipJoin;
  String? ipLogin;
  String? uid;
  String? phone;
  String? phoneCode;
  String? name;
  String? email;
  String? password;
  bool? emailVerify;

  String? pinSet;
  String? pin;

  String? code2fa;
  bool? set2fa;

  String? refCode;
  String? sponRefCode;
  String? sponName;
  String? uidSpon;
  String? uidParent;
  String? setSide; // L, R, ''
  String? sideL;
  String? sideR;

  String? picAvatarUrl;
  String? picFrontIdUrl;
  String? picBehindIdUrl;
  String? picSelfIdUrl;
  String? country;
  String? personalID;
  String? kyc; // pending - done

  String? role;

  bool? lockTrans;
  bool? lockWithdraw;
  bool? lockCom;
  bool? lockVolume;

  int? rank;
  double? rankPack;
  int? comAgent;
  int? comAgentF1Max;

  int? investPack;
  int? totalInvests;
  int? buyNum;

  int? totalLendingNumBNB;
  double? totalLendingBNB;
  int? totalLendingNumUSDT;
  double? totalLendingUSDT;

  int? totalStakNumDOT;
  double? totalStakDOT;
  int? totalStakNumPOLYGON;
  double? totalStakPOLYGON;
  int? totalStakNumSHIBA;
  double? totalStakSHIBA;
  double? totalStakToUsd;

  int? teamF1;
  int? teamF1Act;
  int? teamGen;
  int? teamL;
  int? teamR;

  double? volumeMe;
  double? volumeTeam;
  double? volumeL;
  double? volumeR;

  double? wToken;
  double? wUsd;
  double? wBnb;
  double? wDot;
  double? wPoly;
  double? wShiba;
  double? wCelo;
  double? wCom;
  double? wComBNB;
  double? wComUSDT;
  double? wComTotal;
  double? wComTotalBNB;
  double? wComTotalUSDT;
  double? wProfit;
  double? wProfitTotal;

  double? totalDeposit;
  double? totalDepUsdt;
  double? totalDepSvs;
  double? totalDepBnb;
  double? totalDepUsdtBep20;

  String? addrDepTrc;
  String? addrDepBep;
  String? addrWTrc;
  String? addrWBep;

  Timestamp? timeCreated;
  Timestamp? timeLogin;
  Timestamp? timeLock;

  List<dynamic>? upPa;
  List<dynamic>? upLine;
  List<dynamic>? bank;

  int? step1;
  int? step2;
  int? step3;
  int? step4;
  int? step5;
  bool? airDropDone;

  String? airTeleU;
  int? airTeleid;
  String? airTwU;

  UserModel({
    Key? key,
    this.ipJoin,
    this.ipLogin,
    this.uid,
    this.phone,
    this.phoneCode,
    this.name,
    this.email,
    this.password,
    this.emailVerify,
    this.pinSet,
    this.pin,
    this.code2fa,
    this.set2fa,
    this.refCode,
    this.sponRefCode,
    this.uidSpon,
    this.sponName,
    this.uidParent,
    this.setSide,
    this.sideL,
    this.sideR,
    this.picAvatarUrl,
    this.picFrontIdUrl,
    this.picBehindIdUrl,
    this.picSelfIdUrl,
    this.country,
    this.personalID,
    this.kyc,
    this.role,
    this.lockTrans,
    this.lockWithdraw,
    this.lockCom,
    this.lockVolume,
    this.rank,
    this.rankPack,
    this.investPack,
    this.totalInvests,
    this.buyNum,
    this.comAgent,
    this.comAgentF1Max,
    this.totalLendingNumBNB,
    this.totalLendingBNB,
    this.totalLendingNumUSDT,
    this.totalLendingUSDT,
    this.totalStakNumDOT,
    this.totalStakDOT,
    this.totalStakNumPOLYGON,
    this.totalStakPOLYGON,
    this.totalStakNumSHIBA,
    this.totalStakSHIBA,
    this.totalStakToUsd,
    this.teamF1,
    this.teamF1Act,
    this.teamGen,
    this.teamL,
    this.teamR,
    this.volumeMe,
    this.volumeTeam,
    this.volumeL,
    this.volumeR,
    this.wToken,
    this.wUsd,
    this.wBnb,
    this.wDot,
    this.wPoly,
    this.wShiba,
    this.wCelo,
    this.wCom,
    this.wComBNB,
    this.wComUSDT,
    this.wComTotal,
    this.wComTotalBNB,
    this.wComTotalUSDT,
    this.wProfit,
    this.wProfitTotal,
    this.totalDepUsdt,
    this.totalDepBnb,
    this.totalDepUsdtBep20,
    this.totalDepSvs,
    this.timeCreated,
    this.timeLogin,
    this.timeLock,
    this.addrDepTrc,
    this.addrDepBep,
    this.addrWTrc,
    this.addrWBep,
    this.upPa,
    this.upLine,
    this.bank,
    this.step1,
    this.step2,
    this.step3,
    this.step4,
    this.step5,
    this.airDropDone,
    this.airTeleU,
    this.airTeleid,
    this.airTwU,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) {
    uid = documentSnapshot.id;
    ipJoin = documentSnapshot.data()!['ipJoin'] ?? '';
    ipLogin = documentSnapshot.data()!['ipLogin'] ?? '';

    pinSet = documentSnapshot.data()!['pinSet'] ?? '';
    pin = documentSnapshot.data()!['pin'] ?? '';
    set2fa = documentSnapshot.data()!['set2fa'] ?? false;
    code2fa = documentSnapshot.data()!['code2fa'] ?? '';

    refCode = documentSnapshot.data()!['refCode'] ?? '';
    sponRefCode = documentSnapshot.data()!['sponRefCode'] ?? '';

    uidSpon = documentSnapshot.data()!['uidSpon'] ?? '';
    sponName = documentSnapshot.data()!['sponName'] ?? '';
    uidParent = documentSnapshot.data()!['uidParent'] ?? '';

    name = documentSnapshot.data()!['name'] ?? '';
    email = documentSnapshot.data()!['email'] ?? '';
    phone = documentSnapshot.data()!['phone'] ?? '';
    phoneCode = documentSnapshot.data()!['phoneCode'] ?? '';
    emailVerify = documentSnapshot.data()!['emailVerify'] ?? false;

    addrDepTrc = documentSnapshot.data()!['addrDepTrc'] ?? '';
    addrDepBep = documentSnapshot.data()!['addrDepBep'] ?? '';
    addrWTrc = documentSnapshot.data()!['addrWTrc'] ?? '';
    addrWBep = documentSnapshot.data()!['addrWBep'] ?? '';

    picAvatarUrl = documentSnapshot.data()!['picAvatarUrl'] ?? '';
    picFrontIdUrl = documentSnapshot.data()!['picFrontIdUrl'] ?? '';
    picBehindIdUrl = documentSnapshot.data()!['picBehindIdUrl'] ?? '';
    picSelfIdUrl = documentSnapshot.data()!['picSelfIdUrl'] ?? '';
    country = documentSnapshot.data()!['country'] ?? '';
    personalID = documentSnapshot.data()!['personalID'] ?? '';
    kyc = documentSnapshot.data()!['kyc'] ?? '';

    setSide = documentSnapshot.data()!['setSide'] ?? 'L';
    sideL = documentSnapshot.data()!['sideL'] ?? '';
    sideR = documentSnapshot.data()!['sideR'] ?? '';

    lockCom = documentSnapshot.data()!['lockCom'] ?? false;
    lockTrans = documentSnapshot.data()!['lockTrans'] ?? false;
    lockWithdraw = documentSnapshot.data()!['lockWithdraw'] ?? false;
    lockVolume = documentSnapshot.data()!['lockVolume'] ?? false;

    role = documentSnapshot.data()!['role'] ?? '';

    rank = documentSnapshot.data()!['rank'] as int? ?? 0;
    rankPack = documentSnapshot.data()!['rankPack'] as double? ?? 0.0;
    investPack = documentSnapshot.data()!['investPack'] as int? ?? 0;
    totalInvests = documentSnapshot.data()!['totalInvests'] ?? 0;
    buyNum = documentSnapshot.data()!['buyNum'] as int? ?? 0;
    comAgent = documentSnapshot.data()!['comAgent'] as int? ?? 50;
    comAgentF1Max = documentSnapshot.data()!['comAgentF1Max'] ?? 0;

    totalLendingNumBNB = documentSnapshot.data()!['totalLendingNumBNB'] ?? 0;
    totalLendingBNB = documentSnapshot.data()!['totalLendingBNB'] ?? 0;
    totalLendingNumUSDT = documentSnapshot.data()!['totalLendingNumUSDT'] ?? 0;
    totalLendingUSDT = documentSnapshot.data()!['totalLendingUSDT'] ?? 0;

    totalStakNumDOT = documentSnapshot.data()!['totalLendingDOT'] ?? 0;
    totalStakDOT = documentSnapshot.data()!['totalStakDOT'] ?? 0;
    totalStakPOLYGON = documentSnapshot.data()!['totalStakPOLYGON'] ?? 0;
    totalStakNumPOLYGON = documentSnapshot.data()!['totalStakNumPOLYGON'] ?? 0;
    totalStakNumSHIBA = documentSnapshot.data()!['totalStakNumSHIBA'] ?? 0;
    totalStakSHIBA = documentSnapshot.data()!['totalStakSHIBA'] ?? 0;
    totalStakToUsd = documentSnapshot.data()!['totalStakToUsd'] ?? 0;

    wUsd = documentSnapshot.data()!['wUsd'] as double? ?? 0.0;
    wBnb = documentSnapshot.data()!['wBnb'] as double? ?? 0.0;
    wDot = documentSnapshot.data()!['wDot'] as double? ?? 0.0;
    wPoly = documentSnapshot.data()!['wPoly'] as double? ?? 0.0;
    wShiba = documentSnapshot.data()!['wShiba'] as double? ?? 0.0;
    wCelo = documentSnapshot.data()!['wCelo'] as double? ?? 0.0;

    wToken = documentSnapshot.data()!['wToken'] as double? ?? 0.0;

    wCom = documentSnapshot.data()!['wCom'] as double? ?? 0.0;
    wComTotal = documentSnapshot.data()!['wComTotal'] as double? ?? 0.0;

    wComBNB = documentSnapshot.data()!['wComBNB'] as double? ?? 0.0;
    wComUSDT = documentSnapshot.data()!['wComUSDT'] as double? ?? 0.0;
    wComTotalBNB = documentSnapshot.data()!['wComTotalBNB'] as double? ?? 0.0;
    wComTotalUSDT = documentSnapshot.data()!['wComTotalUSDT'] as double? ?? 0.0;

    wProfit = documentSnapshot.data()!['wProfit'] as double? ?? 0.0;
    wProfitTotal = documentSnapshot.data()!['wProfitTotal'] as double? ?? 0.0;

    totalDepUsdt = documentSnapshot.data()!['totalDepUsdt'] as double? ?? 0.0;
    totalDepBnb = documentSnapshot.data()!['totalDepBnb'] as double? ?? 0.0;
    totalDepUsdtBep20 = documentSnapshot.data()!['totalDepUsdtBep20'] as double? ?? 0.0;
    totalDepSvs = documentSnapshot.data()!['totalDepSvs'] as double? ?? 0.0;

    volumeMe = documentSnapshot.data()!['volumeMe'] as double? ?? 0.0;
    volumeTeam = documentSnapshot.data()!['volumeTeam'] as double? ?? 0.0;
    volumeL = documentSnapshot.data()!['volumeL'] as double? ?? 0.0;
    volumeR = documentSnapshot.data()!['volumeR'] as double? ?? 0.0;

    teamF1 = documentSnapshot.data()!['teamF1'] as int? ?? 0;
    teamF1Act = documentSnapshot.data()!['teamF1Act'] as int? ?? 0;
    teamGen = documentSnapshot.data()!['teamGen'] as int? ?? 0;
    teamL = documentSnapshot.data()!['teamL'] as int? ?? 0;
    teamR = documentSnapshot.data()!['teamR'] as int? ?? 0;

    timeCreated = documentSnapshot.data()!['timeCreated'] ?? Timestamp.now();
    timeLogin = documentSnapshot.data()!['timeLogin'] ?? Timestamp.now();
    timeLock = documentSnapshot.data()!['timeLock'] ?? Timestamp.now();
    upLine = documentSnapshot.data()!['upLine'] ?? <dynamic>[];
    upPa = documentSnapshot.data()!['upPa'] ?? <dynamic>[];

    bank = documentSnapshot.data()!['bank'] ?? <dynamic>[];

    step1 = documentSnapshot.data()!['step1'] ?? 0;
    step2 = documentSnapshot.data()!['step2'] ?? 0;
    step3 = documentSnapshot.data()!['step3'] ?? 0;
    step4 = documentSnapshot.data()!['step4'] ?? 0;
    step5 = documentSnapshot.data()!['step5'] ?? 0;
    airDropDone = documentSnapshot.data()!['airDropDone'] ?? false;

    airTeleU = documentSnapshot.data()!['airTeleU'] ?? '';
    airTeleid = documentSnapshot.data()!['airTeleid'] ?? 0;
    airTwU = documentSnapshot.data()!['airTwU'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'name': name ?? '',
        'email': email ?? '',
        'phone': phone ?? '',
        'phoneCode': phoneCode ?? '',
        'sponRefCode': (sponRefCode ?? '').toLowerCase(),
        'refCode': (refCode ?? '').toLowerCase(),
        'uidSpon': uidSpon ?? '',
        'wUsd': wUsd ?? 0,
        'wCom': wCom ?? 0,
        'wComTotal': wComTotal ?? 0,
        'volumeMe': volumeMe ?? 0,
        'timeCreated': timeCreated ?? Timestamp.now(),
        'ipJoin': ipJoin ?? '',
      };
}
