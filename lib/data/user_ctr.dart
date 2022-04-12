import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/models.dart';
import 'services/services.dart';
import 'utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserCtr extends GetxController {
  static UserCtr get to => Get.find();

  final Rx<SetModel?> _set = Rx<SetModel?>(null);
  SetModel? get set => _set.value;
  set set(SetModel? setData) => _set.value = setData;
  Rx<double?> get rateUpDown => ((set!.priceToken! - set!.priceTokenOld!) / set!.priceTokenOld!).obs;

  final Rx<User?> _userAuth = Rx<User?>(null);
  User? get userAuth => _userAuth.value;
  set userAuth(User? user) => _userAuth.value = user;

  final Rx<UserModel?> _userDB = Rx<UserModel?>(null);
  UserModel? get userDB => _userDB.value;
  set userDB(UserModel? userDB) => _userDB.value = userDB;

  void streamGetUserDB({required String uid}) async {
    _userDB.value = null;
    _userDB.value = await getUserDB(uid: uid);
    _set.value = null;
    _set.bindStream(setStream()!);
    if (_userDB.value == null) return;
    _userDB.bindStream(getUserStream(uid: uid)!);
    debugPrint('GetDB, bindStream done: ${stringDot(text: uid)}');
    updateLoginTimeIp(uid: UserCtr.to.userAuth!.uid);
  }

  String appLink = LocalStore.storeRead(key: 'url');
  String get reLink => '$appLink?ref=${userDB!.refCode}';
  // Rx<String> get refAll => checkRefLink().obs;
  // Rx<String> get refOfUid => checkRefOfUid(uid: userAuth!.uid).obs;
  // Rx<String> get ref => ((refOfUid.value != '') ? refOfUid.value : refAll.value).obs;

  // List<Bank> get bankList {
  //   List<Bank> retVal = [];
  //   if (_userDB.value!.bank!.isNotEmpty) {
  //     for (var element in _userDB.value!.bank!) {
  //       retVal.add(Bank.fromJson(element));
  //     }
  //   }
  //   return retVal;
  // }

  Rx<String?> wBankChoose = ''.obs;
  Rx<String?> swapChoose = ''.obs;
  Rx<String?> walletChoose = 'wBnb'.obs;
  Rx<String> depChainChoose = ''.obs;

  Rx<double> withdrawAmount = 0.0.obs;

  Rx<String> textIntro = Rx<String>('Connecting data...');

  final Future<String> waitFunc = Future<String>.delayed(const Duration(seconds: 5), () => 'Done!');

  Rx<double> bnbPrice = 0.0.obs;
  Future<double> bnbGetP() async {
    return bnbPrice.value = await getBnbPriceApi();
  }

  @override
  onInit() {
    // FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    _userAuth.bindStream(_auth.userChanges());
    super.onInit();
  }

  @override
  void dispose() {
    _userDB.close();
    _set.close();
    wBankChoose.close();
    clear();
    super.dispose();
  }

  @override
  void onClose() {
    _userDB.close();
    _set.close();
    clear();
    super.onClose();
  }

  void stopStreamUserDB() {
    _userDB.close();
    _set.close();
  }

  void clear() {
    _userAuth.value = null;
    _userDB.value = null;
    _set.value = null;
    // LocalStore.storeRemove(key: 'spon');
  }

  // void userDBRrefresh() {
  //   _userDB.call();
  //   _userDB.refresh();
  // }

  void signOut() async {
    try {
      await _auth.signOut();
      clear();
      refreshApp();
    } catch (e) {
      statusAuth = AuthExceptionHandler.handleException(e);
    }
  }
}
