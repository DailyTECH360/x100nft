import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/services/twofa_page.dart';
import '../../data/services/wg_global/num_page.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AllLendingCtrST extends GetxController {
  static AllLendingCtrST get to => Get.find();

  final Rx<List<LendingModel>> _uInvestlist = Rx<List<LendingModel>>([]);
  List<LendingModel> get uInvestlist => _uInvestlist.value;

  RxDouble investAmount = (UserCtr.to.userDB != null ? getWalletBalance(UserCtr.to.walletChoose.value!).floor().toDouble() : 0.0).obs;

  Rx<bool> seView = Rx<bool>(false);

  @override
  void onInit() {
    seView.value = false;
    _uInvestlist.bindStream(getUserInvestList(uid: UserCtr.to.userDB!.uid!));
    super.onInit();
  }

  @override
  void dispose() {
    _uInvestlist.close();
    _uInvestlist.value = <LendingModel>[];
    super.dispose();
  }

  // investCount(List<InvestModel> _list) async {
  //   int totalInvestsNum = 0;
  //   double totalInvestAmount = 0.0;
  //   if (_list.isNotEmpty) {
  //     totalInvestAmount = 0;
  //     totalInvestsNum = 0;
  //     for (var element in _list) {
  //       if (element.symbol! == 'USDT') {
  //         if (element.amount! > 0) {
  //           totalInvestsNum++;
  //           totalInvestAmount = totalInvestAmount + element.amount!;
  //         }
  //       }
  //     }
  //     updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {
  //       'totalInvests${getTokenNameByWallet(element)}': totalInvestsNum,
  //     });
  //   }
  // }

  Stream<List<LendingModel>> getUserInvestList({required String uid}) {
    return _firestore.collection('lendings').where('uid', isEqualTo: uid).orderBy('timeCreated', descending: true).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> query) {
        List<LendingModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(LendingModel.fromDocumentSnapshot(documentSnapshot: element));
        }
        // investCount(retVal);
        return retVal;
      },
    );
  }

  Future<void> lendingBook(BuildContext context, String w) async {
    try {
      Loading.show(text: '$lending...', textSub: '$notCloseApp!');
      if (investAmount.value > 0) {
        await saveAnyField(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: w, amount: -investAmount.value);
        await addTransactions(
          amount: -investAmount.value,
          symbol: getSymbolByWallet(w),
          type: 'Lending',
          note: 'Lending ${NumF.decimals(num: investAmount.value)} ${getSymbolByWallet(w)}',
          mainUserDB: UserCtr.to.userDB!,
        );
      }

      // TẠO GIAO DỊCH INVEST:
      await addDocToCollDynamic(coll: 'lendings', data: {
        'amount': investAmount.value,
        'rateD': (UserCtr.to.set!.lendingProfitDay!),
        'symbol': getSymbolByWallet(w),
        'getDoneDay': 0,
        'getDoneAmount': 0,
        'cycleDay': (30 * 12),
        'status': 'run',
        'uid': UserCtr.to.userDB!.uid!,
        'uidSpon': UserCtr.to.userDB!.uidSpon!,
        'comAgent': 50,
        'name': UserCtr.to.userDB!.name!,
        'timeCreated': Timestamp.now(),
      });
      Loading.hide();
      showTopSnackBar(context, CustomSnackBar.success(message: '$investCreatedDone: ${NumF.decimals(num: investAmount.value)}'), additionalTopPadding: 60);
    } catch (e) {
      debugPrint('Error: $e');
      // rethrow;
    }
  }

  deleLending(BuildContext context, {required LendingModel data}) {
    if (UserCtr.to.userDB != null) {
      Get.defaultDialog(
          middleText: '$delInvest\n$sure'.toUpperCase(),
          textConfirm: yes,
          textCancel: no,
          confirmTextColor: Colors.white,
          onConfirm: () async {
            Get.back();

            await deleteAny(coll: 'lendings', docId: data.id!);
            showTopSnackBar(context, CustomSnackBar.success(message: '$delInvestDone: ${NumF.decimals(num: data.amount!)}'), additionalTopPadding: 60);
          });
    }
  }
}

Widget lendingAdd(BuildContext context) {
  final TextEditingController _textAmountCtr = TextEditingController();
  Future wAmount(BuildContext context, String text) async {
    // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
    AllLendingCtrST.to.investAmount.value = double.parse(text == '' ? '0' : text);
    // debugPrint('aWAdd: $text');
  }

  return GetX<AllLendingCtrST>(
    init: Get.put(AllLendingCtrST()),
    builder: (_) {
      if (UserCtr.to.set != null && UserCtr.to.userDB != null && _.investAmount.value >= 0) {
        _textAmountCtr.text = '${_.investAmount.value}';
        _textAmountCtr.selection = TextSelection.fromPosition(TextPosition(offset: _textAmountCtr.text.length));
        int _chia = 1;
        double _step = UserCtr.to.set!.minInvest! / _chia;
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySwatch,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(width: 1, color: Colors.white38),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${lending.toUpperCase()} ${UserCtr.to.set!.lendingProfitDay!}%/$day', style: const TextStyle(fontWeight: FontWeight.bold)),
                  // const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: Text('%')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(NumPage(getText: wAmount, initText: '${UserCtr.to.set!.minInvest!}')),
                    child: TextFormField(
                      enabled: false,
                      controller: _textAmountCtr,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white24,
                        labelText:
                            '$accBalance: ${NumF.decimals(num: getWalletBalance(UserCtr.to.walletChoose.value!).floor().toDouble())} ${getSymbolByWallet(UserCtr.to.walletChoose.value!)}',
                        hintText: 'eg: 1000',
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primarySwatch)),
                        disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      // onChanged: (value) {
                      //   _.investAmount.value = double.parse(value);
                      //   if (double.parse(value) == 0) {
                      //     _.investAmount.value = UserCtr.to.set!.minInvest!;
                      //   }
                      // },
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  child: const Icon(Icons.cancel, color: Colors.grey, size: 30),
                  onTap: () => _.investAmount.value = UserCtr.to.set!.minInvest!,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Icon(Icons.remove, color: Colors.white),
                  style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
                  onPressed: () {
                    if (_.investAmount.value >= ((_step * _chia) + _step)) {
                      _.investAmount.value = _.investAmount.value - _step;
                    }
                  },
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    child: Text('${lending.toUpperCase()} ${UserCtr.to.set!.lendingProfitDay!}%/$day', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(primary: AppColors.primarySwatch),
                    onPressed: () {
                      if (CheckSV.minCheck(context, notiText: lendingMin, dk: _.investAmount.value >= (UserCtr.to.set!.minInvest!), min: (UserCtr.to.set!.minInvest!))) {
                        if (CheckSV.balanceCheck(context, dk: _.investAmount.value <= getWalletBalance(UserCtr.to.walletChoose.value!).floor())) {
                          Get.defaultDialog(
                              title: '$confirm:',
                              middleText: '$lending: ${NumF.decimals(num: _.investAmount.value)}${getSymbolByWallet(UserCtr.to.walletChoose.value!)}\n$sure',
                              textConfirm: yes,
                              confirmTextColor: Colors.white,
                              buttonColor: AppColors.primaryColor,
                              textCancel: no,
                              cancelTextColor: AppColors.primaryColor,
                              onConfirm: () {
                                Get.back();
                                if (UserCtr.to.userDB!.set2fa != true) {
                                  _.lendingBook(context, UserCtr.to.walletChoose.value!);
                                } else {
                                  verify2faForm(context, callback: () => _.lendingBook(context, UserCtr.to.walletChoose.value!));
                                }
                                _textAmountCtr.text = '';
                              });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  child: const Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
                  onPressed: () => _.investAmount.value = _.investAmount.value + _step,
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primaryDeep, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    ),
                    child: const Text('MAX', style: TextStyle(color: Colors.white)),
                  ),
                  onTap: () {
                    _.investAmount.value = getWalletBalance(UserCtr.to.walletChoose.value!).floorToDouble();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      } else {
        return Center(child: Wg.noData());
      }
    },
  );
}
