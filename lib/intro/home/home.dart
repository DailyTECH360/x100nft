import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/services.dart';
import '../../data/services/twofa_page.dart';
import '../../data/services/wg_global/wallet_wg.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../../modules/deposit/deposit_page.dart';
import '../../modules/income/in_page.dart';
import '../../modules/lending/mylending_ctrst.dart';
import '../../modules/lending/mylending_page.dart';
import '../../modules/notice/noti_ctrst.dart';
import '../../modules/notice/noti_page.dart';
import '../../modules/profile/profile_page.dart';
import '../../modules/staking/mystaking_ctrst.dart';
import '../../modules/staking/mystaking_page.dart';
import '../../modules/swap/swap_page.dart';
import '../../modules/team/team_page.dart';
import '../../modules/wallet/wallet_page.dart';
import '../../modules/wallet/withdraw_page.dart';
import 'menu_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    checkLinkAndRefreshApp();
    UserCtr.to.bnbGetP();
    bool runPin = false;
    return GetX<UserCtr>(builder: (_) {
      if (_.userDB != null) {
        if (_.userDB!.uidSpon!.length >= 3) {
          if (_.set != null) {
            if (!runPin) {
              runPin = true;
              Future.delayed(Duration.zero, () async {
                pinCheck(context);
              });
            }
            return Container(
              decoration: BoxDecoration(gradient: AppColors.linearG1),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  centerTitle: false,
                  title: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.asset('assets/brand/X100NFT_Ngang.png', height: 40),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Wg.keyChangeButton(),
                        // refreshButton(),
                        // SimpleLangPicker(onSelected: Get.updateLocale, selected: Get.locale),
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            IconButton(icon: const Icon(Icons.notifications, color: Colors.white), tooltip: "My Notify".tr, onPressed: () => Get.to(const NotiPage())),
                            GetX<NotiCtrST>(
                                init: NotiCtrST(),
                                builder: (_) {
                                  if (_.listNotiUnread.isNotEmpty) {
                                    return Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(color: Colors.red[700], border: Border.all(color: Colors.black26), shape: BoxShape.circle),
                                        child: Text('${_.listNotiUnread.length}', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center));
                                  } else {
                                    return const Text('');
                                  }
                                }),
                          ],
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
                drawer: const Drawer(child: Menu()),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: WalletWg(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Wrap(
                              runSpacing: 5,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                Visibility(
                                  visible: (UserCtr.to.walletChoose.value! == 'wBnb' || UserCtr.to.walletChoose.value! == 'wUsd'),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.add_chart, color: Colors.white),
                                      label: Text(lending.toUpperCase(), style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                                      onPressed: () {
                                        AllLendingCtrST.to.seView.value = true;
                                        Get.to(const LendingPage());
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (UserCtr.to.walletChoose.value! != 'wUsd'),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.leaderboard, color: Colors.white),
                                      label: Text(staking.toUpperCase(), style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                                      onPressed: () {
                                        AllStakingCtrST.to.seView.value = true;
                                        Get.to(const StakingPage());
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (UserCtr.to.walletChoose.value! == 'wBnb' || UserCtr.to.walletChoose.value! == 'wUsd'),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.multiple_stop, color: Colors.white),
                                      label: Text(swap.toUpperCase(), style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                                      onPressed: () {
                                        AllLendingCtrST.to.seView.value = true;
                                        Get.to(const SwapPage());
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.cloud_download, color: Colors.white),
                                    label: Text(withdraw.toUpperCase(), style: (Get.width < 370) ? const TextStyle(fontSize: 12) : const TextStyle(fontSize: 14)),
                                    onPressed: () {
                                      if (CheckSV.lockWithdrawCheck(context, dk: !UserCtr.to.userDB!.lockWithdraw!)) {
                                        if (CheckSV.minCheck(context,
                                            symbol: getSymbolByWallet(UserCtr.to.walletChoose.value!),
                                            dk: getWalletBalance(UserCtr.to.walletChoose.value!) >= UserCtr.to.set!.minWithdraw!,
                                            min: UserCtr.to.set!.minWithdraw!)) {
                                          UserCtr.to.userDB!.set2fa != true ? Get.to(const WithdrawPage()) : verify2faForm(context, callback: () => Get.to(const WithdrawPage()));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: (Responsive.isDesktop(context) || Responsive.isTablet(context))
                                ? Row(
                                    children: [
                                      Expanded(child: profileWgHome(context, _)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          teamWgHome(context, _),
                                          const SizedBox(height: 10),
                                          volumeWgHome(context, _),
                                        ],
                                      )),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      profileWgHome(context, _),
                                      const SizedBox(height: 10),
                                      teamWgHome(context, _),
                                      const SizedBox(height: 10),
                                      volumeWgHome(context, _),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/brand/X100NFT_Ngang.png'),
                          ),
                          const SizedBox(height: 100),
                          Center(
                            child: Wg.countdownTimerNew(
                              endTime: UserCtr.to.set!.deadline!.millisecondsSinceEpoch,
                              sizeTime: 20,
                              colorText: Colors.white,
                              colorTime: Colors.orangeAccent,
                            ),
                          ),
                          const CopyRightVersion(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.payments, color: Colors.white),
                  onPressed: () => Get.to(const DepositPage()),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                bottomNavigationBar: BottomAppBar(
                  color: AppColors.primaryLight.withOpacity(0.8),
                  elevation: 16,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 5,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(onPressed: () => Get.to(const LendingPage()), child: const Icon(Icons.add_chart, color: Colors.white)),
                        MaterialButton(onPressed: () => Get.to(const StakingPage()), child: const Icon(Icons.leaderboard, color: Colors.white)),
                        const SizedBox(width: 60),
                        MaterialButton(onPressed: () => Get.to(const IncomePage()), child: const Icon(Icons.account_balance_wallet, color: Colors.white)),
                        MaterialButton(onPressed: () => Get.to(const WalletPage()), child: const Icon(Icons.account_balance, color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const NoSetPage();
          }
        } else {
          return NoSponPage(userDB: _.userDB!);
        }
      } else {
        return const NoUserDBPage();
      }
    });
  }

  Widget profileWgHome(BuildContext context, UserCtr uData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
        // gradient: AppColors.linearG5,
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Wg.logoBoxCircle(maxH: 130, color: Colors.black54, func: () => Get.to(const ProfilePage())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wg.textRowWg(title: '${"Name".tr}: ', text: uData.userDB!.name!, style: const TextStyle(color: Colors.white, fontSize: 16), max: true),
              Visibility(
                visible: uData.userDB!.phone != '',
                child: Wg.textRowWg(title: '${"Phone".tr}: ', text: uData.userDB!.phone!, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              Visibility(
                visible: uData.userDB!.email != '',
                child: Wg.textRowWg(title: '${"Email".tr}: ', text: uData.userDB!.email!, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              Wg.textRowWg(title: '$commission: ', text: '${uData.userDB!.comAgent!}%', style: const TextStyle(color: Colors.white, fontSize: 14)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('${"Level".tr}: ', style: const TextStyle(color: Colors.white, fontSize: 16)),
              //     Text('${uData.userDB!.rank!}', style: const TextStyle(color: Colors.white, fontSize: 16)),
              //   ],
              // ),
              // Wg.textRowWg(
              //     title: '$balance: ',
              //     text: '${NumF.decimals(num: uData.userDB!.wUsd!)}$symbolUsdt',
              //     style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('${"Point".tr}: ', style: const TextStyle(color: Colors.white, fontSize: 16)),
              //     Text(NumF.decimals(num: uData.userDB!.wUsd!), style: const TextStyle(color: Colors.white, fontSize: 16)),
              //   ],
              // ),
              refLinkWg(reLink: UserCtr.to.reLink, size: 14),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text('Aff UID: ', style: TextStyle(color: Colors.white, fontSize: 16)),
              //     Wg.textDot(before: 3, text: '${uData.userDB!.uid}', style: const TextStyle(color: Colors.white, fontSize: 16)),
              //     // Text('${controller.userDB!.uid}', style: TextStyle(color: Colors.white, fontSize: 12)),
              //     const SizedBox(width: 5),
              //     InkWell(
              //       child: const Icon(Icons.copy, color: Colors.white, size: 16),
              //       onTap: () {
              //         Clipboard.setData(
              //           ClipboardData(text: '${uData.userDB!.uid}'),
              //         ).then((v) {
              //           Get.snackbar('${"Copy done".tr}: ', '${uData.userDB!.uid}', snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
              //         });
              //       },
              //     )
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget teamWgHome(BuildContext context, UserCtr uData) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            child: const CircleAvatar(radius: 30, backgroundColor: Colors.white30, child: Icon(Icons.groups, color: Colors.white, size: 50)),
            onTap: () => Get.to(const TeamPage()),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Team".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wg.textRowWg(title: 'F1: ', text: '${uData.userDB!.teamF1!}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  // const Text('F1: ', style: TextStyle(fontSize: 16, color: Colors.white)),
                  // Text('${uData.userDB!.teamF1}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(width: 8),
                  Wg.textRowWg(title: 'F1Act: ', text: '${uData.userDB!.teamF1Act!}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  // const Text('F1Act: ', style: TextStyle(fontSize: 16, color: Colors.white)),
                  // Text('${uData.userDB!.teamF1Act}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
              Wg.textRowWg(title: '$teamTotal: ', text: '${uData.userDB!.teamGen!}', style: const TextStyle(color: Colors.white, fontSize: 14)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('${"Team total".tr}: ', style: const TextStyle(fontSize: 16, color: Colors.white)),
              //     Text('${uData.userDB!.teamGen!}', style: const TextStyle(fontSize: 16, color: Colors.white)),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget volumeWgHome(BuildContext context, UserCtr uData) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white30,
              child: Icon(Icons.insert_chart_outlined, color: Colors.white, size: 50),
            ),
            onTap: () => Get.to(const LendingPage()),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(myinvest, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Wg.textRowWg(
                  title: '$myLending: ',
                  text: '${(uData.userDB!.totalLendingNumBNB! + uData.userDB!.totalLendingNumUSDT!)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('${"Volume".tr}: ', style: const TextStyle(fontSize: 16, color: Colors.white)),
              //     Text(NumF.decimals(num: uData.userDB!.volumeMe!), style: const TextStyle(fontSize: 16, color: Colors.white)),
              //   ],
              // ),
              Wg.textRowWg(
                  title: '$myStaking: ', text: '${NumF.decimals(num: uData.userDB!.totalStakToUsd!)} $symbolAll', style: const TextStyle(color: Colors.white, fontSize: 14)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('${"Volume All".tr}: ', style: const TextStyle(fontSize: 16, color: Colors.white)),
              //     Text(NumF.decimals(num: uData.userDB!.volumeTeam!), style: const TextStyle(fontSize: 16, color: Colors.white)),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
