import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/models.dart';
import '../user_ctr.dart';
import '../utils.dart';
import 'fb_firestore.dart';
import 'local_sv.dart';

class CheckSV {
  static bool emptyCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notEmpty!'));
    }
    return false;
  }

  static bool wBankCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$wAcc!'));
    }
    return false;
  }

  static bool minCheck(BuildContext context, {required bool dk, required double min, String? notiText, String? symbol}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '${notiText ?? minNeed}: ${NumF.decimals(num: min)}${symbol ?? symbolUsdt}!'));
    }
    return false;
  }

  static bool balanceCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notBalanceEnough!'));
    }
    return false;
  }

  static bool balanceCheckAirDrop(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notBalanceEnough!\n$minNeed \$1 BNB $inWallet.'));
    }
    return false;
  }

  static bool levelDkCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, const CustomSnackBar.error(message: 'You don\'t have a Stacked package yet!'));
    }
    return false;
  }

  static bool internetCheck(BuildContext context) {
    if (Connectivity().isConnected.value) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notInternetC!'));
    }
    return false;
  }

  static bool roleCheck(BuildContext context, {required bool role}) {
    if (role) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: noRight));
    }
    return false;
  }

  static bool stepAirDropCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$step5!'));
    }
    return false;
  }

  static bool lockTransCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notEli! You\'re locked.'));
    }
    return false;
  }

  static bool lockWithdrawCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notEli!'));
    }
    return false;
  }

  static bool checkTimeLocal(BuildContext context) {
    tz.initializeTimeZones();
    final local = tz.getLocation('Asia/Bangkok'); // Asia/Bangkok - America/New_York
    var localTime = tz.TZDateTime.now(local);
    if (localTime.hour > 8) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notSupport!'));
    }
    return false;
  }

  static bool checkMondayTimeUTCConvertCOM(BuildContext context) {
    final nowUtc = DateTime.now().toUtc();
    final h = nowUtc.hour;
    const monday = DateTime.monday;
    final weekday = nowUtc.weekday;
    // debugPrint('Test FUNC: ${(weekday == monday && h >= 0 && h <= 24) ? ok : no}');
    if (weekday == monday && h >= 0 && h <= 24) {
      return true;
    } else {
      showTopSnackBar(context, const CustomSnackBar.error(message: 'You can convert from 00:00 - 24:00 UTC every Monday!'));
    }
    return false;
  }

  static bool checkMonthTimeUTCConvertCOM(BuildContext context) {
    final nowUtc = DateTime.now().toUtc();
    final day = nowUtc.day;
    // const monday = DateTime.monday;
    // final weekday = nowUtc.weekday;
    debugPrint('Day convert: $day');
    if (day == 1) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: convertTimeMonth));
    }
    return false;
  }

  static bool checkPaSameMe(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, const CustomSnackBar.error(message: 'Parent can\'t be yourself!'));
      return false;
    }
  }

  static bool yourselfCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notSelf!'));
      return false;
    }
  }

  static bool yourselfCheckTrans(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notSelfTrans!'));
      return false;
    }
  }

  static bool checkSponSameMe(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, const CustomSnackBar.error(message: 'Referrer\'sponsor can\'t be yourself!'));
      LocalStore.storeRemove(key: 'spon');
      updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'sponRefCode': ''});
      return false;
    }
  }

  static bool yourselfSponCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$notSelf!'));
      LocalStore.storeRemove(key: 'spon');
      updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'sponRefCode': ''});
      return false;
    }
  }

  static bool balanceBnbFeeAddrCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.info(message: '$tryAgain!'));
      // The system is busy now! please come back later.
    }
    return false;
  }

  static bool balanceUsdtPayAddCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.info(message: '$tryAgain!'));
      // The system is busy now! please come back later.
    }
    return false;
  }

  static bool addrNoBuyCheck(BuildContext context, {required bool dk}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: '$buyNot!'));
      return false;
    }
  }

  static bool maxBuyCheck(BuildContext context, {required bool dk, required double maxBuy}) {
    if (dk) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: "$buyMax: ${NumF.decimals(num: maxBuy)}"));
      return false;
    }
  }

  static bool maxAirDropCheck(BuildContext context) {
    SetModel? set = UserCtr.to.set;
    if (set != null) {
      if ((set.totalTokenAir! + 25000) < 10000000000) {
        return true;
      } else {
        showTopSnackBar(context, CustomSnackBar.error(message: "$airMax: 10.000.000.000"));
        return false;
      }
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: "$airMax: 10.000.000.000"));
      return false;
    }
  }

  static bool convert48hCheck(BuildContext context, {required int timeCreatedMilis}) {
    int time48 = timeCreatedMilis + oneDMilis * 2;
    if (nowMilis > time48) {
      return true;
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: "$updated48!"));
      return false;
    }
  }

  static bool convertOpenCheck(BuildContext context) {
    SetModel? set = UserCtr.to.set;
    if (set != null) {
      if (set.convertOpen!) {
        return true;
      } else {
        showTopSnackBar(context, CustomSnackBar.error(message: "$convertClose!"));
        return false;
      }
    } else {
      showTopSnackBar(context, CustomSnackBar.error(message: "$convertClose!"));
      return false;
    }
  }
}
