import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/lending/mylending_ctrst.dart';
import '../../user_ctr.dart';
import '../../utils.dart';

WalletInfo? wwChoose;

class WalletWg extends StatefulWidget {
  final List<String>? re;
  const WalletWg({Key? key, this.re}) : super(key: key);

  @override
  State<WalletWg> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWg> {
  List<WalletInfo> wList = walletDataList;
  removeList() {
    if (widget.re != null) {
      for (var eRe in widget.re!) {
        WalletInfo findE = wList.firstWhere((element) => element.wallet == eRe);
        wList.remove(findE);
      }
    }
  }

  @override
  void initState() {
    wList = walletDataList;
    removeList();
    wwChoose = wList.firstWhere((element) => element.wallet == UserCtr.to.walletChoose.value!);
    AllLendingCtrST.to.investAmount.value = getWalletBalance(UserCtr.to.walletChoose.value!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: 140,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: wList.length,
        itemBuilder: (context, index) => InkWell(
          child: WalletCon(wInfo: wList[index]),
          onTap: () => setState(() {
            wwChoose = wList[index];
            UserCtr.to.walletChoose.value = wwChoose!.wallet!;
          }),
        ),
      ),
    );
  }
}

class WalletCon extends StatelessWidget {
  final WalletInfo wInfo;
  const WalletCon({Key? key, required this.wInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 120),
          decoration: BoxDecoration(
            gradient: wwChoose == wInfo ? AppColors.linearG2 : AppColors.linearG3,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.zero, topRight: Radius.circular(20), topLeft: Radius.zero),
            border: Border.all(color: Colors.white54, width: 1),
            // image: const DecorationImage(image: AssetImage("assets/bg/bg_black.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wg.logoBoxCircle(pic: wInfo.iconImage!, maxH: 50, colorBorder: Colors.white, color: Colors.white30),
              // CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Image.asset(wInfo.iconImage!, height: 40)),
              const SizedBox(height: 5),
              GetX<UserCtr>(
                init: UserCtr(),
                builder: (_) {
                  return Text(NumF.decimals(num: getWalletBalance(wInfo.wallet!)), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18));
                },
              ),
              Text('${wInfo.symbol!} ', style: const TextStyle(color: Colors.white60, fontSize: 18)),
              // const Divider(color: Colors.white24, height: 20, thickness: 1),
              // wInfo!.btWg ?? Container(),
            ],
          ),
        ),
        Visibility(
          visible: wwChoose == wInfo,
          child: const Icon(Icons.check_circle, color: Colors.greenAccent),
        ),
      ],
    );
  }
}

class WalletInfo {
  final String? symbol, name, iconImage;
  final String? wallet;
  final Widget? btWg;
  WalletInfo({this.symbol, this.name, this.iconImage, this.wallet, this.btWg});
}

List<WalletInfo> walletDataList = [
  WalletInfo(
    name: getSymbolByWallet('wBnb'),
    symbol: getSymbolByWallet('wBnb'),
    iconImage: getLogoByWallet(getSymbolByWallet('wBnb')),
    wallet: 'wBnb',
  ),
  WalletInfo(
    name: getSymbolByWallet('wUsd'),
    symbol: getSymbolByWallet('wUsd'),
    iconImage: getLogoByWallet(getSymbolByWallet('wUsd')),
    wallet: 'wUsd',
  ),
  WalletInfo(
    name: getSymbolByWallet('wDot'),
    symbol: getSymbolByWallet('wDot'),
    iconImage: getLogoByWallet(getSymbolByWallet('wDot')),
    wallet: 'wDot',
  ),
  WalletInfo(
    name: getSymbolByWallet('wPoly'),
    symbol: getSymbolByWallet('wPoly'),
    iconImage: getLogoByWallet(getSymbolByWallet('wPoly')),
    wallet: 'wPoly',
  ),
  WalletInfo(
    name: getSymbolByWallet('wShiba'),
    symbol: getSymbolByWallet('wShiba'),
    iconImage: getLogoByWallet(getSymbolByWallet('wShiba')),
    wallet: 'wShiba',
  ),
  WalletInfo(
    name: getSymbolByWallet('wAda'),
    symbol: getSymbolByWallet('wAda'),
    iconImage: getLogoByWallet(getSymbolByWallet('wAda')),
    wallet: 'wAda',
  ),
];
