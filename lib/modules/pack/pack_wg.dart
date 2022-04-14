import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/models/tokenprice_m.dart';
import '../../data/models/u_model.dart';
import '../../data/services/services.dart';
import '../../data/services/twofa_page.dart';
import '../../data/services/wg_global/num_page.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

class PackageWidget extends StatefulWidget {
  final UserModel mainU;
  final UserModel chooseU;
  const PackageWidget({Key? key, required this.mainU, required this.chooseU}) : super(key: key);

  @override
  State<PackageWidget> createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> {
  final TextEditingController _textAmountCtr = TextEditingController();

  Future<void> numOfInput(BuildContext context, String text) async {
    setState(() => _textAmountCtr.text = (text == '' ? '0' : text));
  }

  @override
  void initState() {
    _textAmountCtr.text = getWalletBalance(UserCtr.to.walletChoose.value!).floorToDouble().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getAnyCollList(coll: 'packs', by: 'cycle'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // debugPrint('2');
        if (snapshot.connectionState == ConnectionState.waiting) {
          // debugPrint('3');
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.error != null) {
            // debugPrint('4');
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.orangeAccent)),
            );
          } else {
            // debugPrint("Ok".tr);
            return Container(
              // width: context.size!.width,
              height: 380,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white54, width: 1),
                      image: const DecorationImage(image: AssetImage("assets/bg/bg_gmap2.png"), fit: BoxFit.cover),
                    ),
                    child: Card(
                      elevation: 5,
                      color: AppColors.primaryLight.withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/brand/192.png', height: 80),
                                const Divider(color: Colors.white38, height: 10, thickness: 1),
                                Text('${snapshot.data!.docs[index]['title']}', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                Text('${snapshot.data!.docs[index]['cycle']} $day', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                const Divider(color: Colors.white38, height: 10, thickness: 1),
                                Text('$profit/$day', style: TextStyle(color: AppColors.white, fontSize: 16)),
                                Text('${snapshot.data!.docs[index]['rateD']}%', style: TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                                // Text(investBonusSpecail, style: TextStyle(color: AppColors.white, fontSize: 16)),
                                const Divider(color: Colors.white38, height: 32, thickness: 1),
                                InkWell(
                                  onTap: () {
                                    Get.to(NumPage(
                                        max: getWalletBalance(UserCtr.to.walletChoose.value!).floorToDouble(), getText: numOfInput, initText: '${UserCtr.to.set!.minInvest!}'));
                                  },
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 200),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: _textAmountCtr,
                                      keyboardType: TextInputType.none,
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.black12,
                                        labelText:
                                            '$balance : ${NumF.decimals(num: getWalletBalance(UserCtr.to.walletChoose.value!).floorToDouble())} ${getSymbolByWallet(UserCtr.to.walletChoose.value!)}',
                                        labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
                                        hintText: 'eg: 1000000',
                                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                                        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple[300]!)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.leaderboard, color: Colors.white),
                                  label: Text(staking.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: AppColors.primarySwatch,
                                    // padding: const EdgeInsets.symmetric(vertical: paddingDefault / 2, horizontal: paddingDefault),
                                  ),
                                  onPressed: () {
                                    double _rateD = snapshot.data!.docs[index]['rateD'] ?? 1;
                                    int _cycleDay = snapshot.data!.docs[index]['cycle'] ?? 90;
                                    double investAmount = double.parse((_textAmountCtr.text == '' ? '0' : _textAmountCtr.text));

                                    if (CheckSV.balanceCheck(context, dk: getWalletBalance(UserCtr.to.walletChoose.value!) >= investAmount)) {
                                      if (CheckSV.minCheck(context, dk: investAmount >= UserCtr.to.set!.minInvest!, min: UserCtr.to.set!.minInvest!)) {
                                        stakingConfirm(context, num: investAmount, rateD: _rateD, cycleDay: _cycleDay, findU: widget.chooseU);
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }

  Future<void> stakingConfirm(context, {required double num, required double rateD, required int cycleDay, required UserModel findU}) async {
    Alert(
      context: context,
      style: const AlertStyle(
        isOverlayTapDismiss: true,
        isCloseButton: true,
        isButtonVisible: true,
        // alertPadding: EdgeInsets.all(8),
        buttonAreaPadding: EdgeInsets.all(8),
        animationType: AnimationType.grow,
        animationDuration: Duration(milliseconds: 400),
        constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
      ),
      type: AlertType.info,
      content: Column(
        children: [
          Text('$confirm:', style: TextStyle(color: AppColors.black)),
          const SizedBox(height: 8),
          ConfirmWg(findU: findU, stakAmount: num, cycleDay: cycleDay),
          const SizedBox(height: 8),
          Text(sure.toUpperCase(), style: TextStyle(color: AppColors.black)),
        ],
      ),
      buttons: [
        DialogButton(
            child: Text(ok.toUpperCase(), style: TextStyle(color: AppColors.white)),
            color: AppColors.primaryColor,
            onPressed: () async {
              Get.back();
              if (widget.mainU.set2fa != true) {
                stakingBook(context, amount: num, rateD: rateD, cycleDay: cycleDay);
              } else {
                verify2faForm(context, callback: () async {
                  stakingBook(context, amount: num, rateD: rateD, cycleDay: cycleDay);
                });
              }
            }),
      ],
    ).show();
  }

  Future<void> stakingBook(context, {required double amount, required double rateD, required int cycleDay}) async {
    try {
      Loading.show(text: '${staking.tr}...', textSub: '$notCloseApp!');
      if (amount > 0) {
        await saveAnyField(coll: 'users', doc: widget.chooseU.uid!, field: UserCtr.to.walletChoose.value!, amount: -amount);
        await addTransactions(
          amount: -amount,
          symbol: getSymbolByWallet(UserCtr.to.walletChoose.value!),
          type: 'Staking',
          note: 'Staking ${NumF.decimals(num: amount)} ${getSymbolByWallet(UserCtr.to.walletChoose.value!)}',
          mainUserDB: widget.chooseU,
        );
        // await saveAnyField(coll: 'users', doc: widget.chooseU.uid!, field: 'totalStaking${getSymbolByWallet(UserCtr.to.walletChoose.value!)}', amount: amount);
      }

      TokenPricePk pri = await getTokenPricePanecakeApi(symbol: getSymbolByWallet(UserCtr.to.walletChoose.value!));
      double _bnbPrice = 0;
      if (getSymbolByWallet(UserCtr.to.walletChoose.value!) == 'BNB') {
        _bnbPrice = await getBnbPriceApi();
      }

      // TẠO GIAO DỊCH INVEST:
      await addDocToCollDynamic(coll: 'stakings', data: {
        'amount': amount,
        'rateD': rateD,
        'rateSymbolUsd': (getSymbolByWallet(UserCtr.to.walletChoose.value!) == 'BNB') ? _bnbPrice : pri.data!.priceUsd!,
        'symbol': getSymbolByWallet(UserCtr.to.walletChoose.value!),
        'getDoneDay': 0,
        'getDoneAmount': 0,
        'cycleDay': cycleDay,
        'status': 'run',
        'uid': widget.chooseU.uid!,
        'uidSpon': widget.chooseU.uidSpon!,
        // 'comAgent': widget.chooseU.comAgent!,
        'name': widget.chooseU.name!,
        'byAdminUid': UserCtr.to.userDB!.uid!,
        'byAdminName': UserCtr.to.userDB!.name!,
        'timeCreated': Timestamp.now(),
        // 'type': widget.chooseU.type! == 'NO' ? 'NO' : '',
      });
      // GHI VOLUME
      Loading.hide();
      showTopSnackBar(context, CustomSnackBar.success(message: '$investCreatedDone: ${NumF.decimals(num: amount)}'), additionalTopPadding: 60);
    } catch (e) {
      debugPrint('Error: $e');
      // rethrow;
    }
  }
}

class ConfirmWg extends StatelessWidget {
  final UserModel findU;
  final double stakAmount;
  final int cycleDay;
  const ConfirmWg({Key? key, required this.findU, required this.stakAmount, required this.cycleDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('To user:', style: TextStyle(color: Colors.black54)),
        Text(stringDot(before: 8, after: 9, text: '${findU.phone != '' ? findU.phone : findU.email}'), style: const TextStyle(color: Colors.black)),
        // Visibility(visible: findU.type! == 'NO', child: Text(findU.type!, style: const TextStyle(color: Colors.red))),
        Text('$staking:', style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
        Text('${NumF.decimals(num: stakAmount)} ${getSymbolByWallet(UserCtr.to.walletChoose.value!)}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        Text('$cycleDay $day', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
