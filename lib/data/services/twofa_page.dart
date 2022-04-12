import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:base32/base32.dart';

import 'services.dart';
import 'wg_global/num_page.dart';
import '../utils.dart';
import '../user_ctr.dart';

class Set2faPage extends GetWidget<UserCtr> {
  const Set2faPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _secret = base32.encodeString(UserCtr.to.userDB!.refCode!);
    String _toQR = 'otpauth://totp/$brandName:${UserCtr.to.userDB!.phone! != '' ? UserCtr.to.userDB!.phone! : UserCtr.to.userDB!.email!}?secret=$_secret&issuer=$brandName';

    updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'code2fa': _secret});
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(title: Text(twoFa2)),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: AppColors.bgImageLock1,
          // gradient: AppColors.linearG5,
        ),
        child: SingleChildScrollView(child: Obx(() {
          if (controller.userDB!.code2fa! != '') {
            return Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: const [
                      Icon(Icons.security, size: 120, color: Colors.white24),
                      Icon(Icons.verified_user, size: 80, color: Colors.white54),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Obx(() {
                        if (controller.userDB!.uid != null) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(protected_, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white)),
                              Text(appTwoFa, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white60)),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: !controller.userDB!.set2fa!,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('$secretKey:', style: const TextStyle(fontSize: 14, color: Colors.white)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Wg.textDot(
                                            text: controller.userDB!.code2fa!,
                                            before: 10,
                                            after: 0,
                                            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                                        InkWell(
                                          child: const Icon(Icons.copy, color: Colors.white),
                                          onTap: () {
                                            Clipboard.setData(
                                              ClipboardData(text: controller.userDB!.code2fa!),
                                            ).then((v) {
                                              Get.snackbar('$secretCopy: ', controller.userDB!.code2fa!, snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    QrImage(data: _toQR, version: QrVersions.auto, size: 230.0, backgroundColor: Colors.white),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                label: controller.userDB!.set2fa == true
                                    ? Text(dis.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.white))
                                    : Text(ena.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                                icon: const Icon(Icons.fingerprint, color: Colors.white54, size: 35),
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  shape: const StadiumBorder(),
                                  primary: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                ),
                                onPressed: () {
                                  verify2faForm(context, callback: () {
                                    return updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {
                                      'set2fa': (UserCtr.to.userDB!.set2fa == true) ? false : true,
                                    });
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        })),
      ),
    );
  }
}

bool veryfy2faOtp(String _otherCode) {
  final _ketqua = OTP.constantTimeVerification(
    OTP.generateTOTPCodeString(
      UserCtr.to.userDB!.code2fa!,
      DateTime.now().millisecondsSinceEpoch,
      length: 6,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    ),
    _otherCode,
  );
  return _ketqua;
}

// Verify 2FA FORM:
verify2faForm(BuildContext context, {Function? callback}) {
  final TextEditingController _otherCode = TextEditingController();
  Future addText(BuildContext context, String text) async {
    _otherCode.text = (text == '') ? '0' : text;
  }

  Get.defaultDialog(
    textCancel: no,
    content: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(Icons.security, size: 100, color: AppColors.primaryLight),
                Icon(Icons.verified_user, size: 60, color: AppColors.primaryColor),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => Get.to(NumPage(getText: addText)),
              child: TextField(
                enabled: false,
                controller: _otherCode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  labelText: twoFa1,
                  labelStyle: const TextStyle(color: Colors.black, fontSize: 13),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.verified, color: Colors.white),
              label: Text(confirm, style: const TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 5,
                primary: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
              ),
              onPressed: () {
                if (_otherCode.text == '') {
                  Get.snackbar(notice, '$notEmpty!', backgroundColor: Colors.white70);
                } else {
                  if (veryfy2faOtp(_otherCode.text)) {
                    Get.back();
                    callback!();
                  } else {
                    _otherCode.text = '';
                    Get.snackbar(notice, '$notMatch2fa!', backgroundColor: Colors.white70);
                  }
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
