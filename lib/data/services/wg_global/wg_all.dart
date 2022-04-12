import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/services.dart';
import '../../../data/utils.dart';
import '../../../modules/income/in_page.dart';
import '../../../modules/notice/noti_ctrst.dart';
import '../../../modules/notice/noti_page.dart';
import '../../../modules/team/team_page.dart';
import '../../../modules/wallet/wallet_page.dart';
import '../../models/models.dart';
import '../../user_ctr.dart';
import '../../utils.dart';
import 'init_set.dart';
import 'vk_multi.dart';

class Wg {
  static Widget keyChangeButton() {
    return Visibility(
        visible: UserCtr.to.userDB != null && UserCtr.to.userDB!.role == 'dev',
        child: IconButton(icon: const Icon(Icons.fingerprint), color: Colors.white, onPressed: () => scanAddressKeyChange()));
  }

  static Widget addPackButton() {
    return Visibility(
        visible: UserCtr.to.userDB != null && UserCtr.to.userDB!.role == 'dev',
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => initPack(),
        ));
  }

  static Widget logoBoxCircle({double? maxH, Color? color, double? padding, Color? colorBorder, String? pic, Function? func}) {
    return Container(
      constraints: BoxConstraints(maxHeight: (maxH ?? 190), minHeight: 20),
      padding: EdgeInsets.all(padding ?? 5),
      decoration: BoxDecoration(color: color ?? Colors.black26, shape: BoxShape.circle, border: Border.all(width: 1, color: colorBorder ?? Colors.white30)),
      child: InkWell(
        splashColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: ClipOval(child: Image.asset(pic ?? 'assets/brand/192.png')),
        onTap: (func as Function()?),
      ),
    );
  }

  static Widget miniBox(Widget wg) {
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 1, color: Colors.white38),
          gradient: AppColors.linearG4,
          // color: Colors.white10,
        ),
        child: wg);
  }

  static Widget conCircle({required Widget wg, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: color ?? Colors.white30, border: Border.all(color: Colors.white70), shape: BoxShape.circle),
      child: wg,
    );
  }

  static Widget conBox({required Widget child, Gradient? gradient, Color? color, Color? colorBorder, double? maxW}) {
    return Container(
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(maxWidth: maxW ?? 1000),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(width: 1, color: colorBorder ?? Colors.white12),
          color: color ?? Colors.white10,
          // gradient: gradient ?? AppColors.linearG1,
          // boxShadow: AppColors.neumorpShadow,
        ),
        child: child);
  }

  static Widget linkCon({required String title, required String subtitle, required String pic, String? link}) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        // gradient: AppColors.linearG5,
        color: Colors.white24,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        border: Border.all(width: 1, color: Colors.white12),
        boxShadow: AppColors.neumorpShadow,
      ),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black45,
              child: Image.asset(pic, width: 35),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ],
        ),
        onTap: (link == '') ? null : () async => await launch(link!),
      ),
    );
  }

  static Widget signInButton({String? text, Color? color, Color? colorBorder, required String pic, double? maxH, Function? onTap}) {
    return InkWell(
      onTap: onTap as void Function()?,
      splashColor: Colors.white38,
      hoverColor: Colors.white24,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(width: 1, color: Colors.white12),
          boxShadow: AppColors.neumorpShadow,
          color: color ?? Colors.white24,
          // gradient: AppColors.linearG5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: (maxH ?? 60), minHeight: 20),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: colorBorder ?? Colors.white30),
              ),
              child: Image.asset(pic),
            ),
            Visibility(
                visible: text != null && text.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(text ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )),
          ],
        ),
      ),
    );
  }

  static Widget textDot({required String text, int? before = 5, int? after = 5, String dot = '...', TextStyle style = const TextStyle(color: Colors.black, fontSize: 14)}) {
    return text.length > (before! + after! + 5) ? Text('${text.substring(0, before)}$dot${text.substring(text.length - after)}', style: style) : Text(text, style: style);
  }

  static Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'ajax-document-loader.gif',
          //   width: 200,
          //   height: 200,
          // ),
          const Icon(Icons.sentiment_neutral, size: 80, color: Colors.white30),
          const SizedBox(height: 5),
          Text('No data...!', style: TextStyle(fontSize: 15, color: AppColors.primaryLight)),
        ],
      ),
    );
  }

  static Widget textRowWg(
      {required String title, required String text, bool? max, TextStyle style = const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)}) {
    return Row(
      mainAxisSize: (max != null && max) ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(color: style.color!.withOpacity(0.6), fontSize: style.fontSize)),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: style.color, fontSize: style.fontSize, fontWeight: style.fontWeight)),
      ],
    );
  }

  // HOME -----------------------------------------------------------------------------

  static Widget myWallet({String? nameWallet, Icon? icon, Function? func}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
        color: Colors.white10,
        // gradient: AppColors.linearG5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: icon,
                ),
                onTap: func as Function()?,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$nameWallet', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(NumF.decimals(num: UserCtr.to.userDB!.wUsd!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Visibility(
                visible: nameWallet == 'My Wallet',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('$commission: ', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    Text(NumF.decimals(num: UserCtr.to.userDB!.wComTotal!), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              // Visibility(
              //   visible: nameWallet == 'My Wallet',
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       const Text('Profit: ', style: TextStyle(color: Colors.white60, fontSize: 12)),
              //       Text(NumF.decimals(num: UserCtr.to.userDB!.wProfitTotal!), style: const TextStyle(color: Colors.white, fontSize: 12)),
              //     ],
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }

  static Widget walletWidget(BuildContext context, {double balance = 0, String nameWallet = 'My Wallet', String symbol = '\$', required Widget buttonWidget}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: AppColors.neumorpShadow,
        gradient: AppColors.linearG2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: AppColors.primaryColor, size: 35),
                const SizedBox(width: 5),
                Expanded(child: Text(nameWallet, style: TextStyle(color: AppColors.primaryDeep, fontSize: 16))),
                Text(NumF.decimals(num: balance), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(' $symbol', style: const TextStyle(color: Colors.white54, fontSize: 16)),
              ],
            ),
            const Divider(color: Colors.white24, height: 20, thickness: 2, indent: 20, endIndent: 0),
            Container(child: buttonWidget)
          ],
        ),
      ),
    );
  }

  static Widget walletHome({required UserCtr userCtr}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white12),
        boxShadow: AppColors.neumorpShadow,
        gradient: AppColors.linearG1r,
        // color: Colors.white10,
      ),
      child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('MY WALLET', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 5),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.account_balance_wallet, color: Colors.white, size: 45),
                  ),
                ],
              ),
              const Expanded(child: SizedBox(width: 8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(symbolAll, style: const TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: userCtr.userDB!.wUsd!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('USDT_TRC.png', height: 30),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Com', style: TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: userCtr.userDB!.wCom!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('assets/brand/192.png', height: 30),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(profit, style: const TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: userCtr.userDB!.wProfit!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('assets/brand/192.png', height: 30),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () => Get.to(const WalletPage())),
    );
  }

  static Widget cryptoWallet({required String nameWallet, String? pic, Icon? icon, required double balance, required double price, Function? func}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        // gradient: AppColors.linearGradient5,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: icon ?? Image.asset(pic!, height: 50),
                ),
                onTap: func as void Function()?,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nameWallet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Visibility(
                    visible: (nameWallet == symbolToken),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_sharp, color: Colors.red, size: 13),
                        Text(NumF.decimals(num: 0), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('\$: $price', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(NumF.decimals(num: balance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Visibility(
                visible: (nameWallet == symbolToken),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 13),
                    Text(NumF.decimals(num: balance - 0), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('~\$: ', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  Text(NumF.decimals(num: (balance * price)), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget cryptoWalletBuy({required String nameWallet, String? pic, Icon? icon, required double balance, required double price, Function? func}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3),
        // gradient: AppColors.linearGradient5,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white38),
        boxShadow: AppColors.neumorpShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: icon ?? Image.asset(pic!, height: 50)),
                    onTap: func as void Function()?,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nameWallet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('\$: ${price.toStringAsFixed(8)}', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      Visibility(
                        visible: (nameWallet == symbolToken),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock_sharp, color: Colors.red, size: 13),
                            Text(NumF.decimals(num: 0), style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(NumF.decimals(num: balance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('~\$: ', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      Text(NumF.decimals(num: (balance * price)), style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Visibility(
                    visible: (nameWallet == symbolToken),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 13),
                        Text(NumF.decimals(num: balance - 0), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget incomeHome({required UserCtr userCtr}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(width: 1, color: Colors.white12),
        boxShadow: AppColors.neumorpShadow,
        gradient: AppColors.linearG1r,
        // color: Colors.white10,
      ),
      child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('MY INCOME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 5),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.account_balance, color: Colors.white, size: 45),
                  ),
                ],
              ),
              const Expanded(child: SizedBox(width: 8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('$profit ∑', style: const TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: userCtr.userDB!.wProfitTotal!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('USDT_TRC.png', height: 30),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Com... ∑', style: TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: userCtr.userDB!.wComTotal!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('USDT_TRC.png', height: 30),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('$other ∑', style: const TextStyle(color: Colors.white54)),
                      const SizedBox(width: 5),
                      Text(NumF.decimals(num: 0), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Image.asset('USDT_TRC.png', height: 30),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () => Get.to(const IncomePage())),
    );
  }

  static Widget incomeProWallet({required String nameWallet, String? pic, Icon? icon, required double balance, required double total, Function? func, required UserCtr userCtr}) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (userCtr.walletChoose.value == nameWallet) ? AppColors.primaryLight.withOpacity(0.3) : Colors.white10,
            // gradient: AppColors.linearG5,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(width: 1, color: Colors.white38),
            boxShadow: AppColors.neumorpShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: icon ?? Image.asset(pic!, height: 40)),
                    onTap: func as void Function()?,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nameWallet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${"Total".tr}: ', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(NumF.decimals(num: balance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('$symbold ', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      Text(NumF.decimals(num: total), style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => userCtr.walletChoose.value = nameWallet);
  }

  static Widget incomeWallet({required String nameWallet, String? pic, Icon? icon, Function? func, required UserCtr userCtr}) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (userCtr.walletChoose.value == nameWallet) ? AppColors.primaryLight.withOpacity(0.3) : Colors.white10,
            // gradient: AppColors.linearG5,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(width: 1, color: Colors.white38),
            boxShadow: AppColors.neumorpShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: icon ?? Image.asset(pic!, height: 40)),
                    onTap: func as void Function()?,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nameWallet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${userCtr.userDB!.wComTotalBNB!}: ', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                      Text('${userCtr.userDB!.wComTotalUSDT!}: ', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(NumF.decimals(num: balance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('BNB ', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      Text(NumF.decimals(num: userCtr.userDB!.wComBNB!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('$symbolUsdt ', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      Text(NumF.decimals(num: userCtr.userDB!.wComUSDT!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => userCtr.walletChoose.value = nameWallet);
  }

  static Widget profileWidget({Function? func, required UserCtr userCtr}) {
    return conBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: userCtr.userDB!.rank! > 0 ? AppColors.primaryLight : Colors.white30,
                  child: userCtr.userDB!.rank! > 0
                      ? Text('${userCtr.userDB!.rank}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))
                      : const Icon(Icons.person, size: 45, color: Colors.white),
                ),
                onTap: func as Function()?,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textDot(before: 3, after: 5, text: userCtr.userDB!.name!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      // InkWell(
                      //   child: const Icon(Icons.copy, color: Colors.white, size: 16),
                      //   onTap: () {
                      //     if (copyToClipboardHack('${UserCtr.to.userAuth!.displayName}')) {
                      //       Get.snackbar('Copy RefCode: ', '${UserCtr.to.userAuth!.displayName}',
                      //           snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                      //     }
                      //   },
                      // )
                    ],
                  ),
                  refLinkWg(reLink: UserCtr.to.reLink, size: 14),
                ],
              ),
            ],
          ),
          // InkWell(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     // mainAxisSize: MainAxisSize.min,
          //     children: [
          //       const Text('Total BUY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          //       Text('${NumF.decimals(num:UserCtr.to.userDB!.volumeMe)} $symbolToken', style: const TextStyle(color: Colors.white)),
          //       Text('~${NumF.decimals(num:UserCtr.to.userDB!.volumeMe)} $symbolUsdt', style: const TextStyle(color: Colors.white60)),
          //     ],
          //   ),
          //   onTap: func as void Function()?,
          // ),
        ],
      ),
    );
  }

  static Widget teamWidget(BuildContext context, {required UserCtr userCtr}) {
    return conBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
              child: const CircleAvatar(radius: 30, backgroundColor: Colors.white30, child: Icon(Icons.groups, color: Colors.white, size: 45)),
              onTap: () => Get.to(const TeamPage())),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(affTeam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  textRowWg(title: 'L:', text: '${userCtr.userDB!.teamL}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                  const SizedBox(width: 8),
                  textRowWg(title: ' - R:', text: '${userCtr.userDB!.teamR}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                  const SizedBox(width: 8),
                  textRowWg(title: ' - F1:', text: '${userCtr.userDB!.teamF1}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                  const SizedBox(width: 8),
                  textRowWg(title: ' - F1Act:', text: '${userCtr.userDB!.teamF1Act}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('$teamTotal: ', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  Text('${UserCtr.to.userDB!.teamGen}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Expanded(child: SizedBox(width: 8)),
        ],
      ),
    );
  }

  // TIME -----------------------------------------------------------------------------
  static Widget timeWg({required Timestamp timeData, Color? color = Colors.black, double? size = 20}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(TimeF.dateToSt(date: timeData.toDate(), f: hhmm), style: TextStyle(fontSize: size, color: color!.withOpacity(0.5), fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Text(TimeF.dateToSt(date: timeData.toDate()), overflow: TextOverflow.fade, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }

  static Widget timeWgCo({required Timestamp timeData, Color? color = Colors.black, double? size = 18}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(TimeF.dateToSt(date: timeData.toDate(), f: hhmm), style: TextStyle(fontSize: size, color: color!.withOpacity(0.5), fontWeight: FontWeight.bold)),
        Text(TimeF.dateToSt(date: timeData.toDate()), overflow: TextOverflow.fade, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }

  static Widget timeWgUtc({required Timestamp timeData, Color color = Colors.black, double? size = 18}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(TimeF.dateToSt(date: timeData.toDate(), f: hhmm), style: TextStyle(fontSize: size, color: color.withOpacity(0.5), fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UTC', style: TextStyle(color: color.withOpacity(0.5), fontSize: 9)),
            Text(TimeF.dateToSt(date: timeData.toDate()), style: TextStyle(fontSize: 13, color: color)),
          ],
        ),
      ],
    );
  }

  static Widget timeWidgetFromDatetime({required DateTime? timeData, Color color = Colors.black}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(TimeF.dateToSt(date: timeData!, f: hhmm), style: TextStyle(color: color.withOpacity(0.5), fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UTC', style: TextStyle(color: color.withOpacity(0.5), fontSize: 9)),
            Text(TimeF.dateToSt(date: timeData), overflow: TextOverflow.fade, style: TextStyle(fontSize: 13, color: color)),
          ],
        ),
      ],
    );
  }

  static Widget timeFromMiliWidget({required int timeMilis}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(TimeF.dateToSt(f: hhmm, date: DateTime.fromMillisecondsSinceEpoch(timeMilis).toUtc()),
              style: TextStyle(fontSize: 20, color: AppColors.black, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 5),
        Text(TimeF.dateToSt(date: DateTime.fromMillisecondsSinceEpoch(timeMilis).toUtc()),
            overflow: TextOverflow.fade, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  static Widget timeToDateWidget({required Timestamp timeData}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(TimeF.dateToSt(f: hhmm, date: timeData.toDate()), style: TextStyle(fontSize: 20, color: AppColors.black, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 5),
        Text(TimeF.dateToSt(date: timeData.toDate()), style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }

  static Widget countdownTimerResendMail({String textEnd = '', int? endTime}) {
    return CountdownTimer(
      endWidget: Visibility(visible: !textEnd.isBlank!, child: Text(textEnd)),
      controller: CountdownTimerController(endTime: endTime ?? DateTime.now().millisecondsSinceEpoch + 120000),
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return const Text('You can resend the verify email', style: TextStyle(color: Colors.greenAccent));
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Resend wait: ', style: TextStyle(color: AppColors.primarySwatch), textAlign: TextAlign.center),
            Visibility(
              visible: time.min != null,
              child: Text('${time.min}:', style: TextStyle(color: AppColors.primarySwatch, fontSize: 18), textAlign: TextAlign.center),
            ),
            Visibility(
              visible: time.sec != null,
              child: Text('${time.sec}', style: TextStyle(color: AppColors.primarySwatch, fontSize: 18), textAlign: TextAlign.center),
            ),
          ],
        );
      },
    );
  }

  static Widget countdownTimerOTP({String textEnd = '', Function? onEnd}) {
    int _endTime = DateTime.now().millisecondsSinceEpoch + 120000;
    return CountdownTimer(
      endWidget: Visibility(visible: !textEnd.isBlank!, child: Text(textEnd)),
      controller: CountdownTimerController(endTime: _endTime),
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Column(
            children: [
              const Text(
                  'If still not receive OTP SMS. Please check again:\n- Maybe the phone number is wrong\n- Maybe the wrong country code\n- Maybe the telecommunications network has no signal\n- Maybe the sim to receive SMS is not ready.\nPlease try again, many thanks!'),
              ElevatedButton(
                child: const Text('Try again'),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: onEnd as Function()?,
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time wait: ', style: TextStyle(color: AppColors.primaryColor), textAlign: TextAlign.center),
            Visibility(
              visible: time.min != null,
              child: Text('${time.min}:', style: TextStyle(color: AppColors.primaryDeep, fontSize: 18), textAlign: TextAlign.center),
            ),
            Visibility(
              visible: time.sec != null,
              child: Text('${time.sec}', style: TextStyle(color: AppColors.primaryDeep, fontSize: 18), textAlign: TextAlign.center),
            ),
          ],
        );
      },
    );
  }

  static Widget countdownTimerNew({Color? colorText, Color? colorTime, double? sizeTime, required int endTime, String textEnd = ''}) {
    return CountdownTimer(
      endTime: endTime,
      endWidget: Visibility(visible: !textEnd.isBlank!, child: Text(textEnd)),
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return const Text('NEED BUY NOW!');
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: time.days != null,
                child: Row(children: [
                  textRow4CountWidget(
                    title: 'days:',
                    textMain: '${time.days}',
                    colorMain: colorTime ?? AppColors.primaryDeep,
                    colorTitle: colorText ?? AppColors.primaryColor,
                    size: sizeTime ?? 16,
                  ),
                  const SizedBox(width: 5)
                ])),
            Visibility(
                visible: time.hours != null,
                child: Row(children: [
                  textRow4CountWidget(
                    title: 'hours:',
                    textMain: '${time.hours}',
                    colorMain: colorTime ?? AppColors.primaryDeep,
                    colorTitle: colorText ?? AppColors.primaryColor,
                    size: sizeTime ?? 16,
                  ),
                  const SizedBox(width: 5)
                ])),
            Visibility(
                visible: time.min != null,
                child: Row(children: [
                  textRow4CountWidget(
                    title: 'min:',
                    textMain: '${time.min}',
                    colorMain: colorTime ?? AppColors.primaryDeep,
                    colorTitle: colorText ?? AppColors.primaryColor,
                    size: sizeTime ?? 16,
                  ),
                  const SizedBox(width: 5)
                ])),
            Visibility(
                visible: time.sec != null,
                child: Row(children: [
                  textRow4CountWidget(
                    title: 'sec:',
                    textMain: '${time.sec}',
                    colorMain: colorTime ?? AppColors.primaryDeep,
                    colorTitle: colorText ?? AppColors.primaryColor,
                    size: sizeTime ?? 16,
                  ),
                  const SizedBox(width: 5)
                ])),
          ],
        );
      },
    );
  }

  static Widget textRow4CountWidget({required String title, required String textMain, double size = 14, Color colorMain = Colors.white, Color colorTitle = Colors.white54}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: colorTitle, fontSize: 12)),
        const SizedBox(width: 3),
        Text(textMain, style: TextStyle(color: colorMain, fontSize: size, fontWeight: FontWeight.bold), maxLines: 2, textAlign: TextAlign.center),
      ],
    );
  }

  // -----------------------------------------------------------------------------
  static Widget sponWg() {
    if (UserCtr.to.userDB != null) {
      return textRowWg(
          title: '$spon:',
          text: stringDot(after: 8, text: '${UserCtr.to.userDB!.sponName! == '' ? UserCtr.to.userDB!.uidSpon : UserCtr.to.userDB!.sponName!}'),
          style: const TextStyle(color: Colors.white));
    } else {
      return Container();
    }
  }

  static Widget rank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset('Level_back.png', height: 130),
            Text('${UserCtr.to.userDB!.rank}', style: const TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
        teamCountWg(),
      ],
    );
  }

  static Widget rankNgang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Level: ', style: TextStyle(color: Colors.white60, fontSize: 20)),
            Text('${UserCtr.to.userDB!.rank}', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
        teamCountWg(),
      ],
    );
  }

  static Widget teamCountWg() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), gradient: AppColors.linearG1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wg.textRowWidget(
          //     title: 'Deposit:', textMain: '${Utils.decimals.format(userDB!.totalDepUsdt)} $symbolUsdt,', colorMain: AppColors.primaryLight, size: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wg.textRowWg(title: 'F1:', text: '${UserCtr.to.userDB!.teamF1}', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Wg.textRowWg(title: 'F1Act:', text: '${UserCtr.to.userDB!.teamF1Act}', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Wg.textRowWg(title: 'Total:', text: '${UserCtr.to.userDB!.teamGen}', style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const Divider(color: Colors.white24, height: 10, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wg.textRowWg(title: 'V:', text: NumF.decimals(num: UserCtr.to.userDB!.volumeMe!), style: const TextStyle(color: Colors.white, fontSize: 13)),
              Wg.textRowWg(title: 'W:', text: NumF.decimals(num: UserCtr.to.userDB!.wUsd ?? 0), style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wg.textRowWg(title: 'Pro:', text: NumF.decimals(num: UserCtr.to.userDB!.wProfitTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
              Wg.textRowWg(title: 'Com:', text: NumF.decimals(num: UserCtr.to.userDB!.wComTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget rankTree2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset('Level_back.png', height: 130),
            Text('${UserCtr.to.userDB!.rank}', style: const TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
        teamTree2CountWg(),
      ],
    );
  }

  static Widget rankNgangTree2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Level: ', style: TextStyle(color: Colors.white60, fontSize: 20)),
            Text('${UserCtr.to.userDB!.rank}', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
        teamTree2CountWg(),
      ],
    );
  }

  static Widget teamTree2CountWg() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), gradient: AppColors.linearG1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wg.textRowWidget(
          //     title: 'Deposit:', textMain: '${Utils.decimals.format(userDB!.totalDepUsdt)} $symbolUsdt,', colorMain: AppColors.primaryLight, size: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wg.textRowWg(title: 'L: ', text: '${UserCtr.to.userDB!.teamL}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
              const SizedBox(width: 8),
              Wg.textRowWg(title: ' - R: ', text: '${UserCtr.to.userDB!.teamR}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
              const SizedBox(width: 8),
              Wg.textRowWg(title: ' - F1:', text: '${UserCtr.to.userDB!.teamF1}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
              const SizedBox(width: 8),
              Wg.textRowWg(title: ' - F1Act:', text: '${UserCtr.to.userDB!.teamF1Act}', style: TextStyle(color: AppColors.primaryLight, fontSize: 13)),
              // const SizedBox(width: 8),
              // Wg.textRowWidget(title: ' - T1Tree4:', textMain: '${userDB!.f1Tree4}', colorMain: AppColors.primaryLight, size: 13),
            ],
          ),
          const Divider(color: Colors.white24, height: 10, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('V: ${NumF.decimals(num: UserCtr.to.userDB!.volumeMe!)}', style: const TextStyle(color: Colors.white)),
              Text('V.L: ${NumF.decimals(num: UserCtr.to.userDB!.volumeL!)}', style: const TextStyle(color: Colors.white)),
              Text('V.R: ${NumF.decimals(num: UserCtr.to.userDB!.volumeR!)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  static editNamePopUp(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textCtr = TextEditingController();
    String? _nameText;
    _textCtr.text = UserCtr.to.userDB!.name!;
    Future addTextFunc(String text) async {
      _textCtr.text = text;
      // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
      debugPrint('Text Input: $text');
    }

    PopUp.popUpWg(
      context,
      wg: Form(
        key: _formKey,
        child: Column(
          children: [
            InkWell(
              onTap: () => Get.to(VirtualkeyboardPage(getText: addTextFunc)),
              child: TextFormField(
                controller: _textCtr,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Enter Fullname',
                  hintText: 'eg: Jacky Doe',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                ),
                validator: (String? value) {
                  if (value == '') {
                    return 'The field cannot be empty!';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _nameText = value;
                },
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('SAVE'),
                onPressed: () {
                  hideKeyboard(context);
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  if (_nameText != UserCtr.to.userDB!.name) {
                    updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'name': _nameText}).whenComplete(() {
                      Get.back();
                      showTopSnackBar(context, const CustomSnackBar.success(message: 'New name update is done!'));
                    });
                  } else {
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }

  static editNumPopUp(BuildContext context, {required double initNum, required String field}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textCtr = TextEditingController();
    _textCtr.text = '$initNum';
    PopUp.popUpWg(
      context,
      wg: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _textCtr,
              textInputAction: TextInputAction.done,
              // keyboardType: TextInputType.number,
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                labelText: 'Enter %',
                hintText: 'eg: 0.5',
                labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
              validator: (String? value) {
                if (value == '') {
                  return 'The field cannot be empty!';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('SAVE'),
                onPressed: () async {
                  hideKeyboard(context);
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_textCtr.text != '$initNum') {
                    await updateAnyField(coll: 'settings', docId: 'set', data: {field: double.parse(_textCtr.text)});
                    Get.back();
                    showTopSnackBar(context, const CustomSnackBar.success(message: 'New update is done!'));
                  } else {
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }

  static editTextPopUp(BuildContext context, Future Function(BuildContext, String, String) callback,
      {required String initText, String? step, String? labelText, String? hintText}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textCtr = TextEditingController();
    _textCtr.text = initText;
    PopUp.popUpWg(
      context,
      wg: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _textCtr,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              // // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // keyboardType: const TextInputType.numberWithOptions(decimal: true),
              // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                labelText: labelText ?? 'Enter text',
                hintText: hintText ?? 'eg: agklcse',
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
                return null;
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('SAVE'),
                onPressed: () async {
                  hideKeyboard(context);
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_textCtr.text != initText) {
                    callback(context, _textCtr.text, (step ?? ''));
                    Get.back();
                    showTopSnackBar(context, const CustomSnackBar.success(message: 'New update is done!'));
                  } else {
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }

  static Widget notiWg() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            IconButton(icon: const Icon(Icons.notifications, color: Colors.white), tooltip: 'My Notify', onPressed: () => Get.to(const NotiPage())),
            GetX<NotiCtrST>(
              init: Get.put(NotiCtrST()),
              builder: (notiCtrST) {
                if (notiCtrST.listNotiUnread.isNotEmpty) {
                  return conCircle(
                    color: Colors.red[700],
                    wg: Text('${notiCtrST.listNotiUnread.length}', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
                  );
                } else {
                  return const Text('');
                }
              },
            ),
          ],
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}

class Loading {
  static show({String? title = 'Waiting ...', String? text = '', String? textSub = ''}) {
    Get.defaultDialog(
      title: title!,
      barrierDismissible: false,
      backgroundColor: Colors.white70,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(visible: text!.isNotEmpty, child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))),
          Visibility(visible: textSub!.isNotEmpty, child: Text(textSub, style: const TextStyle(color: Colors.deepOrange))),
          const SizedBox(height: 8),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  static hide() {
    Get.back();
  }
}

class PopUp {
  // Get.defaultDialog(
  //       middleText: 'Address not be empty!',
  //       textConfirm: ok,
  //       confirmTextColor: Colors.white,
  //       onConfirm: () => Get.back(),
  //     );
  //
  static commingSoonDialog() {
    Get.defaultDialog(
      middleText: '$coming!',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  static linkGameAcc({required String gameUid}) {
    Get.defaultDialog(
        title: 'Link game acc',
        titlePadding: const EdgeInsets.all(3),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          children: [
            const Text('Do you do account linking\nwith this gameAcc uid?', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            const Text('Game Uid:'),
            Text(gameUid, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Are you sure?'.toUpperCase()),
          ],
        ),
        textConfirm: confirm,
        textCancel: no,
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          await updateUserDB(data: {'gameGetLink': 'done'}, uid: UserCtr.to.userDB!.uid!);
        },
        onCancel: () async {
          Get.back();
          await updateUserDB(data: {'gameGetLink': '', 'gameUid': ''}, uid: UserCtr.to.userDB!.uid!);
        });
  }

  static notConnected() {
    Get.defaultDialog(
      middleText: '$notConnected!',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  static noSupportComing() {
    Get.defaultDialog(
      middleText: '$coming!\nPlease visit Metamask\'s browser!',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  static noSupport() {
    Get.defaultDialog(
      middleText: 'Not Support!\nPlease visit Metamask\'s browser!',
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  static depositQ() {
    Get.defaultDialog(
      titleStyle: const TextStyle(color: Colors.black),
      middleText: 'Your wallet balance is not enough!\nDo you want to deposit more?',
      middleTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
      textConfirm: 'Deposit NOW',
      confirmTextColor: Colors.white,
      textCancel: no,
      // cancelTextColor: AppColors.primaryDeep,
      onConfirm: () {
        Get.back();
        // Get.to(const DepositPage());
      },
    );
  }

  static maxOutNoti(int timeMilis) {
    Get.defaultDialog(
      titleStyle: const TextStyle(color: Colors.black),
      content: Column(
        children: [
          const Text('Your profit & commission has exceeded 400% of your staked.', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          const Text('You have MaxOUT!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Time left to buy more $symbolToken:', style: const TextStyle(fontWeight: FontWeight.normal)),
          Wg.countdownTimerNew(endTime: (timeMilis + 12 * 3600000)),
        ],
      ),
      textConfirm: ok,
      confirmTextColor: Colors.white,
      textCancel: no,
      cancelTextColor: AppColors.primaryDeep,
      onConfirm: () => Get.back(),
    );
  }

  static receiveInfo() {
    Get.defaultDialog(
      title: 'Receive Info',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wg.textRowWg(title: 'N:', text: '${UserCtr.to.userDB!.name}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Visibility(
            visible: UserCtr.to.userDB!.email!.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wg.textRowWg(
                    title: 'E:', text: '${UserCtr.to.userDB!.email ?? UserCtr.to.userDB!.refCode}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                InkWell(
                  child: const Icon(Icons.copy, color: Colors.black54, size: 18),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: '${UserCtr.to.userDB!.email ?? UserCtr.to.userDB!.refCode}'),
                    ).then((v) {
                      Get.snackbar('Copy success: ', '${UserCtr.to.userDB!.email ?? UserCtr.to.userDB!.refCode}', snackPosition: SnackPosition.TOP, backgroundColor: Colors.black);
                    });
                  },
                )
              ],
            ),
          ),
          // QrImage(data: UserCtr.to.userDB!.refCode!, version: QrVersions.auto, size: 210, backgroundColor: Colors.white54),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wg.textRowWg(title: 'Ref CODE:', text: UserCtr.to.userDB!.refCode!.toLowerCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              InkWell(
                child: const Icon(Icons.copy, color: Colors.black54, size: 18),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: UserCtr.to.userDB!.refCode!.toLowerCase()),
                  ).then((v) {
                    Get.snackbar('Copy success: ', UserCtr.to.userDB!.refCode!.toLowerCase(), snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                  });
                },
              )
            ],
          ),
        ],
      ),
      textConfirm: ok,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  static areYouSure({required String lock, required UserModel uData}) {
    Get.defaultDialog(
      middleText: sure.toUpperCase(),
      textConfirm: 'SURE!',
      confirmTextColor: AppColors.primaryDeep,
      textCancel: skip,
      onConfirm: () async {
        Get.back();
        if (lock == 'lockCom') {
          await updateUserDB(uid: uData.uid!, data: {'lockCom': !uData.lockCom!});
        }
        if (lock == 'lockTrans') {
          await updateUserDB(uid: uData.uid!, data: {'lockTrans': !uData.lockTrans!});
        }
        if (lock == 'lockWithdraw') {
          await updateUserDB(uid: uData.uid!, data: {'lockWithdraw': !uData.lockWithdraw!});
        }
        // if (lock == 'lockVolume') {
        //   await updateUserDB(uid: uData.uid!, data: {'lockVolume': !uData.lockVolume!});
        // }
      },
    );
  }

  static areYouSureFunc(BuildContext context, {required String text, required Future func}) {
    Get.defaultDialog(
        textConfirm: yes,
        textCancel: no,
        confirmTextColor: Colors.white,
        titlePadding: const EdgeInsets.all(3),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(sure.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        onConfirm: () async {
          Get.back();
          await func;
        });
  }

  static defaultDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(3),
      contentPadding: const EdgeInsets.all(10),
      middleText: "RFLUTTER ALERT",
      backgroundColor: Colors.red,
    );
  }

  static dialog() {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: const [
          Text('Dialog'),
        ]),
      ),
      transitionDuration: const Duration(milliseconds: 400),
      barrierDismissible: false,
    );
  }

  static popUpWg(BuildContext context, {required Widget wg, bool? dis, Color? color}) {
    var alertStyle = AlertStyle(
      alertPadding: const EdgeInsets.all(8),
      buttonAreaPadding: const EdgeInsets.all(0),
      isButtonVisible: false,
      isCloseButton: true,
      isOverlayTapDismiss: dis ?? true,
      animationType: AnimationType.grow,
      animationDuration: const Duration(milliseconds: 400),
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 600),
      alertBorder: RoundedRectangleBorder(side: const BorderSide(color: Colors.white30), borderRadius: BorderRadius.circular(20)),
      titleStyle: const TextStyle(color: Colors.black),
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      alertAlignment: Alignment.center,
      backgroundColor: color ?? Colors.white,
    );
    Alert(
      context: context,
      title: null, //"RFLUTTER ALERT",
      desc: null, //"Flutter is more awesome with RFlutter Alert.",
      image: null, //Image.asset("assets/success.png"),
      // type: AlertType.warning,
      style: alertStyle,
      padding: const EdgeInsets.all(10),
      content: wg,
      // buttons: [
      //   DialogButton(child: const Text('Skip'), color: Colors.grey, onPressed: () => Get.back()),
      // ],
    ).show();
  }

  static startPackCheckDialog(int dkNumberF150) {
    Get.defaultDialog(
      content: Column(
        children: [
          Text('* You need to activate the $symbolUsdt${UserCtr.to.set!.startPackAmount!} starter pack,'),
          Text('* Requires $dkNumberF150 F1 activated $symbolUsdt${UserCtr.to.set!.startPackAmount!} starter pack,'),
          Text('* The first time you need to convert the bonus, you need a bonus balance >= ${((dkNumberF150 * 25) + (dkNumberF150 * 10) + 100)}$symbolUsdt'),
          Text('* Next time you need to have bonus balance >= ${((dkNumberF150 * 25) + (dkNumberF150 * 10))}$symbolUsdt'),
        ],
      ),
      textConfirm: ok,
      confirmTextColor: AppColors.primaryDeep,
      onConfirm: () => Get.back(),
    );
  }
}

class NoSponWg extends StatelessWidget {
  const NoSponWg({Key? key, required this.userDB}) : super(key: key);
  final UserModel userDB;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      debugPrint('funcREF befor Form: ${getRefFromSpon()}');
      await funcREF(context, userDB: userDB);
    });
    return FutureBuilder<String>(
      future: UserCtr.to.waitFunc,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
            // debugPrint(ok);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: formLinkREF(context),
              ),
            );
          }
        }
      },
    );
  }
}

class NoSponPage extends StatelessWidget {
  const NoSponPage({Key? key, required this.userDB}) : super(key: key);
  final UserModel userDB;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      debugPrint('funcREF befor Form: ${getRefFromSpon()}');
      await funcREF(context, userDB: userDB);
    });
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      body: FutureBuilder<String>(
        future: UserCtr.to.waitFunc,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
              // debugPrint(ok);
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: SingleChildScrollView(child: formLinkREF(context))),
              );
            }
          }
        },
      ),
    );
  }
}

class NoUserDBPage extends StatelessWidget {
  const NoUserDBPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 15), () {
      UserCtr.to.textIntro.value = '🚫 $dataConnection!\n😊 $comeBack.toUpperCase()}';
    });
    bool runGetUserDB = false;
    return Scaffold(
        backgroundColor: AppColors.primaryDeep,
        body: FutureBuilder<String>(
          future: UserCtr.to.waitFunc,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                // debugPrint(ok);
                if (!runGetUserDB) {
                  runGetUserDB = true;
                  Future.delayed(Duration.zero, () async {
                    UserCtr.to.streamGetUserDB(uid: UserCtr.to.userAuth!.uid);
                  });
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: GetX<UserCtr>(
                      init: UserCtr(),
                      builder: (_) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_off, color: Colors.white38, size: 80),
                            const SizedBox(height: 10),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(_.textIntro.value, style: TextStyle(color: AppColors.primarySwatch), textAlign: TextAlign.center),
                            const Divider(height: 32, color: Colors.white12, thickness: 1),
                            refreshButtonIcon(),
                            const SizedBox(height: 30),
                            IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white), onPressed: () => UserCtr.to.signOut())
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            }
          },
        ));
  }
}

class NoAdmin extends StatelessWidget {
  const NoAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.white38, size: 80),
          const SizedBox(height: 16),
          const Text('No Right!', style: TextStyle(color: Colors.redAccent, fontSize: 20)),
          const Text('ADMIN ZONE ONLY!', style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(height: 32, color: Colors.white12, thickness: 1),
          IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white), onPressed: () => UserCtr.to.signOut())
        ],
      ),
    );
  }
}

class NoSetPage extends StatelessWidget {
  const NoSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      body: FutureBuilder<String>(
        future: UserCtr.to.waitFunc,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
              // debugPrint(ok);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.white38, size: 80),
                    const SizedBox(height: 16),
                    Text(noRight, style: const TextStyle(color: Colors.orangeAccent, fontSize: 20)),
                    const Text('Set Only DEV', style: TextStyle(color: Colors.orangeAccent, fontSize: 20)),
                    const Divider(height: 32, color: Colors.white12, thickness: 1),
                    refreshButtonIcon(),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: UserCtr.to.userDB != null && UserCtr.to.userDB!.role! == 'dev',
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.exit_to_app, color: Colors.white),
                          label: const Text('Init Settings', style: TextStyle(color: Colors.white)),
                          onPressed: () => Get.to(const SetInitPage()),
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white), onPressed: () => UserCtr.to.signOut())
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

Widget formLinkREF(BuildContext context) {
  final TextEditingController _sponSignUpCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Image.asset('assets/brand/192.png', height: 120),
        const SizedBox(height: 8),
        CircleAvatar(radius: 30, child: const Icon(Icons.link, color: Colors.white, size: 50), backgroundColor: AppColors.primaryColor),
        const SizedBox(height: 16),
        Text('Enter Referrer'.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxWidth: 650),
          child: TextFormField(
            controller: _sponSignUpCtr,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.assignment_ind, color: Colors.white),
              labelText: 'Find by email, phone, reflink, refcode',
              hintText: 'abc@abc.abc, 0988...',
              hintStyle: const TextStyle(color: Colors.white60),
              helperStyle: TextStyle(color: AppColors.lightPurple),
              filled: true,
              fillColor: Colors.white24,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white38, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            validator: (String? value) {
              if (value!.length < 5) {
                return 'The field cannot be empty!';
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.save, color: Colors.white),
          label: const Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
            shape: const StadiumBorder(),
            primary: AppColors.primaryLight,
            elevation: 5,
          ),
          onPressed: () async {
            hideKeyboard(context);
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            await linkSPON(context, sponCode: splitRefUrl(textInput: _sponSignUpCtr.text), uDB: UserCtr.to.userDB!);
            // Get.back();
            _sponSignUpCtr.text = '';
          },
        ),
        const Divider(color: Colors.white24, height: 32, thickness: 1),
        IconButton(icon: const Icon(Icons.exit_to_app, color: Colors.white), onPressed: () => UserCtr.to.signOut())
      ],
    ),
  );
}

class RefLinkLRWidget extends StatelessWidget {
  const RefLinkLRWidget({Key? key, required this.controller, required this.reLink}) : super(key: key);

  final UserCtr controller;
  final String reLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //     child: const Text('Left', style: TextStyle(color: Colors.white)),
            //     style: ElevatedButton.styleFrom(primary: controller.userDB!.setSide == 'L' ? Colors.green : Colors.grey),
            //     onPressed: () {
            //       updateUserDB(uid: controller.userDB!.uid!, data: {'setSide': 'L'});
            //     }),
            // const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: const BorderRadius.all(Radius.circular(8)), border: Border.all(width: 1, color: Colors.white38)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wg.textDot(before: 12, after: 5, text: reLink, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  const SizedBox(width: 5),
                  InkWell(
                    child: const Icon(Icons.copy, color: Colors.white, size: 16),
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: controller.reLink),
                      ).then((v) {
                        Get.snackbar('Copy: ', controller.reLink, snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                      });
                    },
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 5),
            // ElevatedButton(
            //     child: const Text('Right', style: TextStyle(color: Colors.white)),
            //     style: ElevatedButton.styleFrom(primary: controller.userDB!.setSide == 'R' ? Colors.green : Colors.grey),
            //     onPressed: () {
            //       updateUserDB(uid: controller.userDB!.uid!, data: {'setSide': 'R'});
            //     }),
          ],
        ),
      ],
    );
  }
}

Widget refLinkWg({required String reLink, double? size, Color? color}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Wg.textDot(before: 12, after: 5, text: reLink, style: TextStyle(color: color ?? Colors.white, fontSize: size ?? 14)),
      const SizedBox(width: 5),
      InkWell(
        child: const Icon(Icons.copy, color: Colors.white70, size: 16),
        onTap: () {
          if (copyToClipboardHack(reLink)) {
            Get.snackbar('$copyDone: ', reLink, snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
          }
        },
      ),
    ],
  );
}

class BankWidget extends GetView<UserCtr> {
  const BankWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.wBankChoose.value = controller.userDB!.bank!.isNotEmpty ? controller.userDB!.bank!.first : '';
    dynamic _onChanged(dynamic val) {
      if (val != null) {
        return controller.wBankChoose.value = val;
      } else {
        return controller.wBankChoose.value = '';
      }
    }

    return Obx(() {
      if (controller.userDB!.bank!.isEmpty) {
        controller.wBankChoose.value = '';
      } else {
        if (controller.userDB!.bank!.length == 1) controller.wBankChoose.value = controller.userDB!.bank!.first;
      }
      return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.white12),
        ),
        child: controller.userDB!.bank!.isNotEmpty
            ? FormBuilderRadioGroup(
                name: 'my_bank',
                activeColor: Colors.greenAccent,
                decoration: InputDecoration(
                  labelText: withdrawAcc,
                  labelStyle: const TextStyle(color: Colors.white),
                  icon: InkWell(
                    splashColor: Colors.white60,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    customBorder: Border.all(width: 1, color: Colors.white38),
                    child: const Icon(Icons.add_circle, color: Colors.white),
                    onTap: () => PopUp.popUpWg(context, wg: bankAddNew(context), color: AppColors.primarySwatch),
                  ),
                ),
                wrapDirection: Axis.vertical,
                validator: FormBuilderValidators.required(context),
                initialValue: controller.wBankChoose.value != '' ? controller.wBankChoose.value : controller.userDB!.bank!.first,
                options: controller.userDB!.bank!.map((data) => FormBuilderFieldOption(value: data, child: bankItem(data))).toList(growable: false),
                onChanged: _onChanged,
                // valueTransformer: (value) {
                //   debugPrint('valueTransformer');
                //   return double.tryParse(value.toString());
                // },
              )
            : ElevatedButton.icon(
                label: Text(addAccReceive),
                icon: const Icon(Icons.add_circle, color: Colors.white),
                // style: ElevatedButton.styleFrom(primary: AppColors.primarySwatch, padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20)),
                onPressed: () => PopUp.popUpWg(context, wg: bankAddNew(context), color: AppColors.primarySwatch),
              ),
      );
    });
  }
}

Widget bankItem(String data) {
  return Row(
    children: [
      Text('${data.toString().split('_').first}: ', style: const TextStyle(color: Colors.white)),
      Text(stringDot(text: data.toString().split('_').last), style: const TextStyle(color: Colors.white)),
      const SizedBox(width: 5),
      InkWell(
          splashColor: Colors.white60,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          customBorder: Border.all(width: 1, color: Colors.white38),
          child: const Icon(Icons.remove_circle_outline, color: Colors.grey),
          onTap: () async => await reAnyFieldValue(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: 'bank', e: data)),
    ],
  );
}

Widget bankAddNew(BuildContext context) {
  final TextEditingController _accTextCtr = TextEditingController();
  String _bank = 'BEP20 Address';
  List<String> genderOptions = ['BEP20 Address'];
  dynamic _onCh(dynamic val) {
    if (val != null) {
      debugPrint(val);
      return _bank = val;
    } else {
      _bank = '';
      return '';
    }
  }

  return Column(
    children: <Widget>[
      FormBuilderTextField(
        controller: _accTextCtr,
        name: 'bank_num',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: address),
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
          FormBuilderValidators.numeric(context),
          FormBuilderValidators.max(context, 60),
        ]),
      ),
      const SizedBox(height: 8),
      FormBuilderDropdown(
        name: 'new_bank',
        allowClear: true,
        decoration: const InputDecoration(labelText: 'Bank'),
        hint: const Text('Select Acc'),
        validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
        initialValue: 'BEP20 Address',
        items: genderOptions.map((gender) => DropdownMenuItem(value: gender, child: Text(gender, style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: _onCh,
      ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        label: Text(addAccReceive.toUpperCase()),
        icon: const Icon(Icons.add_circle, color: Colors.white),
        onPressed: () async {
          hideKeyboard(context);
          if (CheckSV.emptyCheck(context, dk: _accTextCtr.text != '' && _bank != '')) {
            debugPrint('${_accTextCtr.text} $_bank');
            await addAnyFieldValue(coll: 'users', doc: UserCtr.to.userDB!.uid!, field: 'bank', e: '${_bank}_${_accTextCtr.text}');
            Get.back();
          }
        },
      ),
    ],
  );
}
