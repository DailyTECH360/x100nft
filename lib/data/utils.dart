// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';

import 'package:any_base/any_base.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:week_of_year/week_of_year.dart';

import '../modules/todo/todo_page.dart';
import 'app_color.dart';
import 'brand.dart';
import 'services/services.dart';
import 'services/wg_global/wg_all.dart';
import 'string/strings_all.dart';
import 'user_ctr.dart';

export 'app_color.dart';
export 'brand.dart';
export 'responsive.dart';
export 'services/wg_global/wg_all.dart';
export 'string/strings_all.dart';

// flutter run -d web-server
// flutter build web
// firebase deploy --only hosting
// firebase hosting:channel:deploy pre

// firebase deploy --only functions
// firebase deploy --only firestore:indexes
// firebase deploy --only firestore:rules

String stringDot({required String text, int? before = 5, int? after = 5, String dot = '...'}) {
  return text.length > (before! + after! + 1) ? '${text.substring(0, before)}$dot${text.substring(text.length - after)}' : text;
}

String splitRefUrl({required String textInput}) => textInput.trim().isURL ? textInput.trim().split('?ref=').last : textInput.trim();

void hideKeyboard(BuildContext context) => FocusScope.of(context).requestFocus(FocusNode());
refreshApp() => html.window.location.reload();
Widget refreshButton() => IconButton(tooltip: refresh, icon: const Icon(Icons.sync), onPressed: () => refreshApp());

Widget refreshButtonIcon() {
  return ElevatedButton.icon(
    icon: const Icon(Icons.sync, color: Colors.white),
    label: Text(refresh, style: const TextStyle(color: Colors.white)),
    onPressed: () => refreshApp(),
  );
}

getEmailPhone(String email, String phone) => email != '' ? email : phone;

double getWalletBalance(String wallet) {
  if (wallet == 'wUsd') {
    return UserCtr.to.userDB!.wUsd!;
  } else if (wallet == 'wBnb') {
    return UserCtr.to.userDB!.wBnb!;
  } else if (wallet == 'wDot') {
    return UserCtr.to.userDB!.wDot!;
  } else if (wallet == 'wPoly') {
    return UserCtr.to.userDB!.wPoly!;
  } else if (wallet == 'wShiba') {
    return UserCtr.to.userDB!.wShiba!;
  } else if (wallet == 'wCelo') {
    return UserCtr.to.userDB!.wCelo!;
  } else if (wallet == 'wToken') {
    return UserCtr.to.userDB!.wToken!;
  } else if (wallet == 'wCom') {
    return UserCtr.to.userDB!.wCom!;
  } else if (wallet == 'wProfit') {
    return UserCtr.to.userDB!.wProfit!;
  } else {
    return 0;
  }
}

double getWalletComBySymbol(String symbol) {
  if (symbol == 'USDT') {
    return UserCtr.to.userDB!.wComUSDT!;
  } else if (symbol == 'BNB') {
    return UserCtr.to.userDB!.wComBNB!;
  } else {
    return 0;
  }
}

getWalletStringSymbol(String symbol) {
  if (symbol == 'USDT') {
    return 'WUsd';
  } else if (symbol == 'BNB') {
    return 'wBnb';
  } else {
    return '';
  }
}

getWalletTotalStringSymbol(String symbol) {
  if (symbol == 'USDT') {
    return 'wComTotalUSDT';
  } else if (symbol == 'BNB') {
    return 'wComTotalBNB';
  } else {
    return '';
  }
}

String getSymbolByWallet(String wallet) {
  if (wallet == 'wUsd') {
    return symbolUsdt;
  } else if (wallet == 'wBnb') {
    return 'BNB';
  } else if (wallet == 'wDot') {
    return 'DOT';
  } else if (wallet == 'wPoly') {
    return 'POLYGON';
  } else if (wallet == 'wShiba') {
    return 'SHIBA';
  } else if (wallet == 'wCelo') {
    return 'CELO';
  } else if (wallet == 'wToken') {
    return symbolToken;
  } else if (wallet == 'wCom') {
    return symbolUsdt;
  } else if (wallet == 'wProfit') {
    return symbolUsdt;
  } else {
    return '';
  }
}

String getLogoByWallet(String symbol) {
  if (symbol == symbolUsdt) {
    return 'assets/crypto/USDT.png';
  } else if (symbol == 'BNB') {
    return 'assets/crypto/bnb_logo.png';
  } else if (symbol == 'DOT') {
    return 'assets/crypto/dot.png';
  } else if (symbol == 'POLYGON') {
    return 'assets/crypto/poly.png';
  } else if (symbol == 'SHIBA') {
    return 'assets/crypto/shiba.png';
  } else if (symbol == 'CELO') {
    return 'assets/crypto/celo.png';
  } else {
    return '';
  }
}

String getScanHashLink(String symbol) {
  if (symbol == 'BNB' || symbol == 'BSC-USD') {
    return 'https://bscscan.com/tx/';
  } else if (symbol == 'Tether USD') {
    return 'https://tronscan.org/#/transaction/';
  } else {
    return '';
  }
}

String getChainNameByWallet(String wallet) {
  if (wallet == 'wUsd') {
    return chainUsdt.toUpperCase();
  } else if (wallet == 'wToken') {
    return tokenChain.toUpperCase();
  } else {
    return '';
  }
}

String getAddrW(String symbol) {
  if (symbol == 'USDT') {
    return UserCtr.to.userDB!.addrDepTrc!;
  } else if (symbol == 'E99') {
    return UserCtr.to.userDB!.addrDepBep!;
  } else if (symbol == 'SVS') {
    return UserCtr.to.userDB!.addrDepTrc!;
  } else {
    return '';
  }
}

String getChainName(String symbol) {
  if (symbol == 'USDT') {
    return 'Trc20';
  } else if (symbol == 'E99') {
    return 'Trc20';
  } else if (symbol == 'SVS') {
    return 'Bep20';
  } else {
    return '';
  }
}

getJsonUserSaveAddrW({required String symbol, required String addrW}) {
  if (symbol == 'USDT') {
    return {'addrWTrc': addrW};
  } else if (symbol == 'E99') {
    return {'addrWBep': addrW};
  } else if (symbol == 'SVS') {
    return {'addrWTrc': addrW};
  } else {
    return {};
  }
}

creatUuidAll() {
  // Dùng nanoid pub.dev - Gen UUID duy nhất 1 lần
  var id = nanoid().toLowerCase();
  debugPrint(id);
  var customLengthId = nanoid(8).toLowerCase();
  debugPrint(customLengthId);

  // Dùng cách lấy từ millisecondsSinceEpoch - ko dùng pub.dev -  - Gen UUID duy nhất 1 lần;
  int randomNumber = Random().nextInt(999999) + 100000;
  debugPrint('${(DateTime.now().millisecondsSinceEpoch / randomNumber).round()}');

  // Dùng AnyBase pub.dev - MÃ HÓA TẠO TỪ DATA CÓ TRƯỚC
  // Flickr Base 58 alphabet.
  const flickr58 = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
  const dec2hex = AnyBase(AnyBase.dec, AnyBase.hex);
  const dec2flickr = AnyBase(AnyBase.dec, flickr58);
  debugPrint(dec2hex.convert('1234563434')); // returns '1e240'.
  debugPrint(dec2flickr.convert('1234567890')); // returns '2T6u2h'.
  debugPrint(dec2flickr.revert('2T6u2h')); // returns '1234567890'.
}

creatRefCodeUUid() => nanoid(8).toLowerCase();

bool copyToClipboardHack(String text) {
  final textarea = html.TextAreaElement();
  html.document.body!.append(textarea);
  textarea.style.border = '0';
  textarea.style.margin = '0';
  textarea.style.padding = '0';
  textarea.style.opacity = '0';
  textarea.style.position = 'absolute';
  textarea.readOnly = true;
  textarea.value = text;
  textarea.select();
  final result = html.document.execCommand('copy');
  textarea.remove();
  return result;
}

class NumF {
  static String decimals({required double num}) {
    decFun(int dec) => NumberFormat.currency(locale: 'eu', symbol: '', decimalDigits: dec);
    bool isInteger(value) => (value % 1) == 0;
    if (num < 0) {
      double numD = num * (-1);
      if (isInteger(numD)) {
        return '-${decFun(0).format(numD)}';
      } else {
        return '-${decFun(2).format(numD)}';
      }
    } else {
      if (num >= 1) {
        if (isInteger(num)) {
          return decFun(0).format(num);
        } else {
          return decFun(2).format(num);
        }
      } else {
        return num.toStringAsPrecision(2);
      }
    }
  }
}

int oneDMilis = 86400000;
int oneHMilis = 3600000;
int oneSMilis = 1000;
String hhmm = 'HH:mm';
String yyMMdd = 'yyyy-MM-dd';
String yMdHmm = 'yyyy-MM-dd HH:mm';
String yMdHmms = 'yyyy-MM-dd HH:mm:ss';
String mdHmm = 'MM-dd HH:mm';
String dHmm = 'dd HH:mm';
String eMdy = 'EEEE, d.M.y';
// Text(DateFormat(eMdy).format(Timestamp.now().toDate()));
DateTime lastDayOfTheweek = DateTime.now().add(Duration(days: (DateTime.thursday - DateTime.now().weekday))); // Thứ 6

DateTime firstDayOfTheweekSunday = DateTime.now().subtract(Duration(days: DateTime.now().weekday)); // Sunday = 0
DateTime firstDayOfTheweekMonday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)); // Monday = 1
DateTime firstDayOfTheweekMonday2 = DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1) + 7)); // Monday = 1
DateTime firstDayOfTheweekSaturday = DateTime.now().subtract(Duration(days: DateTime.now().weekday + 1)); // Saturday

DateTime firstDayOfThe2weekMondayH00 = DateTime.parse(DateFormat('yyyy-MM-dd').format(firstDayOfTheweekMonday2));

DateTime startDay0H00(DateTime day) => DateTime.parse(DateFormat('yyyy-MM-dd').format(day));
DateTime endDay23H55(DateTime day) => DateTime.parse(DateFormat('yyyy-MM-dd').format(day)).add(const Duration(days: 1)).add(const Duration(minutes: -5));

class TimeF {
  static String dateToSt({required DateTime date, String? f}) => DateFormat(f ?? yyMMdd).format(date);
}

class TimeSpecial {
  // get today's date
  DateTime now = DateTime.now();

  // set it to feb 10th for testing
  //now = now.add(new Duration(days:7));

  int get today => now.weekday;

  // ISO week date weeks start on monday
  // so correct the day number
  int get dayNr => (today + 6) % 7;

  // ISO 8601 states that week 1 is the week
  // with the first thursday of that year.
  // Set the target date to the thursday in the target week
  DateTime get thisMonday => now.subtract(Duration(days: (dayNr)));
  DateTime get thisThursday => thisMonday.add(const Duration(days: 3));

  // Set the target to the first thursday of the year
  // First set the target to january first
  DateTime get firstThursday => DateTime(now.year, DateTime.january, 1);

  // if (firstThursday.weekday != (DateTime.thursday)) => firstThursday = DateTime(now.year, DateTime.january, 1 + ((4 - firstThursday.weekday) + 7) % 7);

  // The weeknumber is the number of weeks between the
  // first thursday of the year and the thursday in the target week
  int get x => thisThursday.millisecondsSinceEpoch - firstThursday.millisecondsSinceEpoch;
  double get weekNumber => x.ceil() / 604800000; // 604800000 = 7 * 24 * 3600 * 1000

  printFunc() {
    debugPrint('Todays date: $now');
    debugPrint('Monday of this week: $thisMonday');
    debugPrint('Thursday of this week: $thisThursday');
    debugPrint('First Thursday of this year: $firstThursday');
    debugPrint('This week is week #${weekNumber.ceil()}');
  }
}

int weekOfYear(DateTime date) {
  // final date = DateTime.now();
  // debugPrint(date.weekOfYear); // Get the iso week of year
  // debugPrint(date.ordinalDate); // Get the ordinal date
  // debugPrint(date.isLeapYear); // Is this a leap year?
  return date.weekOfYear;
}

Future<String> getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // String appName = packageInfo.appName;
  // String packageName = packageInfo.packageName;
  // String version = packageInfo.version;
  // String buildNumber = packageInfo.buildNumber;
  String currentVersion = packageInfo.version + '+' + packageInfo.buildNumber;
  // debugPrint('appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber, currentVersion: $currentVersion');
  return currentVersion;
}

void ssVersion(BuildContext context, {required String vNew}) async {
  String currentVersionGet = await getVersion();
  Version currentVersion = Version.parse(currentVersionGet);
  Version latestVersion = Version.parse(vNew);
  debugPrint('New Version: $latestVersion, Old Version: $currentVersion');
  if (latestVersion > currentVersion) {
    // debugPrint('Update is available');
    Alert(
        context: context,
        style: const AlertStyle(
          isOverlayTapDismiss: false,
          isCloseButton: false,
          isButtonVisible: false,
          // alertPadding: EdgeInsets.all(8),
          buttonAreaPadding: EdgeInsets.all(8),
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 400),
          constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
        ),
        type: AlertType.error,
        content: Column(
          children: [
            Text('$newVersion: $latestVersion'),
            const SizedBox(height: 8),
            refreshButtonIcon(),
          ],
        )).show();
  }
  // final range = VersionConstraint.parse('^2.0.0');
  // debugPrint('currentVersion: $currentVersion -  ${currentVersion.isPreRelease} - ${range.allows(currentVersion)}');
  // for (var version in [
  //   Version.parse('1.2.3-pre'),
  //   Version.parse('2.0.0+123'),
  //   Version.parse('3.0.0-dev'),
  // ]) {
  //   debugPrint('$version ${version.isPreRelease} - ${range.allows(version)}');
  // }
}

getMyIp() async {
  final ipv4 = await Ipify.ipv4();
  debugPrint(ipv4); // 98.207.254.136

  // final ipv6 = await Ipify.ipv64();
  // debugPrint(ipv6); // 98.207.254.136 or 2a00:1450:400f:80d::200e

  // final ipv4json = await Ipify.ipv64(format: Format.JSON);
  // debugPrint(ipv4json); //{'ip':'98.207.254.136'} or {'ip':'2a00:1450:400f:80d::200e'}
  // The response type can be text, json or jsonp
  return ipv4;
}

class CopyRightVersion extends StatelessWidget {
  const CopyRightVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<String>(
            future: getVersion(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              // debugPrint('2');
              if (snapshot.connectionState == ConnectionState.waiting) {
                // debugPrint('3');
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  // debugPrint('4');
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.orangeAccent)));
                } else {
                  if (UserCtr.to.set != null) {
                    ssVersion(context, vNew: UserCtr.to.set!.vNew!);
                  }
                  return Center(child: Wg.textRowWg(title: '$version: ', text: '${snapshot.data}', style: const TextStyle(color: Colors.white)));
                }
              }
            },
          ),
          Text('$copyright © ${DateTime.now().year} $poweredBy $brandName', style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}

class RefWg extends StatelessWidget {
  const RefWg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: LocalStore.storeRead(key: 'ref').isNotEmpty,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$refCode: ", style: const TextStyle(fontSize: 14, color: Colors.white60)),
          Text(LocalStore.storeRead(key: 'ref'), style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}

pinCheck(BuildContext context) async {
  if (UserCtr.to.userDB != null) {
    // String setPin = LocalStore.storeRead(key: 'setPin');
    // String myPin = LocalStore.storeRead(key: '${UserCtr.to.userAuth!.uid}_Pin');
    // debugPrint('setPin: ${UserCtr.to.userDB!.pinSet!}, myPin: ${UserCtr.to.userDB!.pin!}');

    if (UserCtr.to.userDB!.pinSet! == 'On') {
      if (UserCtr.to.userDB!.pin! == '') {
        final inputController = InputController();
        screenLock<void>(
          title: HeadingTitle(text: passcode),
          confirmTitle: HeadingTitle(text: passcodeConfirm),
          context: context,
          correctString: '',
          confirmation: true,
          canCancel: false,
          inputController: inputController,
          didConfirmed: (matchedText) async {
            debugPrint(matchedText);
            await updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'pin': matchedText});
            // LocalStore.storeSaveKey(key: '${UserCtr.to.userAuth!.uid}_Pin', value: matchedText);
            // debugPrint('Set myPin: ${LocalStore.storeRead(key: '${UserCtr.to.userAuth!.uid}_Pin')}');
            Navigator.pop(context);
          },
          footer: TextButton(
            child: Text(returnSetPin),
            onPressed: () => inputController.unsetConfirmed(),
          ),
        );
      } else {
        screenLock<void>(
          title: HeadingTitle(text: passcode),
          confirmTitle: HeadingTitle(text: passcodeConfirm),
          context: context,
          correctString: UserCtr.to.userDB!.pin!,
          canCancel: false,
        );
      }
    }
    //  else if (UserCtr.to.userDB!.pinSet! == '') {
    //   await updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'pinSet': 'On'});
    //   // pinCheck(context);
    // }
  }
}

linkOpen(BuildContext context, {required String url, bool? forceWebView, bool? forceSafariVC, bool? universalLinksOnly}) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: forceWebView ?? false, forceSafariVC: forceSafariVC ?? false, universalLinksOnly: universalLinksOnly ?? false);
  } else {
    showTopSnackBar(context, CustomSnackBar.error(message: 'Could not launch $url'));
  }
}

void launchUrl(BuildContext context, {required String url}) async {
  if (await canLaunch(url)) {
    launch(url);
  } else {
    showTopSnackBar(context, CustomSnackBar.error(message: 'Could not launch $url'));
    throw "Could not launch $url";
  }
}

class TodoHomeIcon extends StatelessWidget {
  const TodoHomeIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              // constraints: BoxConstraints(minWidth: 250, maxHeight: 100, maxWidth: 700),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Colors.white38),
                gradient: AppColors.linearGLight,
                boxShadow: AppColors.neumorpShadow,
              ),
              child: Image.asset('assets/todo_icon.png', height: 100),
            ),
            const SizedBox(height: 5),
            const Text('TODO APP', style: TextStyle(color: Colors.white)),
          ],
        ),
        onTap: () {
          Get.to(const TodoPage());
        });
  }
}

void setPageTitle(BuildContext context, {required String title, String? iconAsset}) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: title,
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
  if (iconAsset != null) {
    updateIcon(iconAsset); //WebMixin is just a helper.  replace  it by your  one.
  }
}

updateIcon(String assetIcon) {
  if (kIsWeb) {
    LinkElement link = (document.querySelector("link[rel*='icon']") ?? document.createElement('link')) as LinkElement;
    link.type = 'image/gif'; //'image/x-icon';
    link.rel = 'shortcut icon';
    link.href = assetIcon;
  }
}
