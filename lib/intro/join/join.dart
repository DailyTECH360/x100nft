import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../data/utils.dart';
import '../../data/services/services.dart';
import '../home/home.dart';
import 'join_ctr.dart';

class JoinPage extends GetWidget<JoinCtr> {
  JoinPage({Key? key}) : super(key: key);
  final TextEditingController _emailLoginCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailLoginCtr.text = LocalStore.storeRead(key: 'email');
    return GetX<JoinCtr>(
        init: Get.put(JoinCtr()),
        builder: (_) {
          if (JoinCtr.toUCtr.userAuth != null) {
            return const Home();
            //ToKoToApp();
            // HomeShopPage();
          } else {
            return Container(
              decoration: const BoxDecoration(image: AppColors.bgNft1),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Wg.logoBoxCircle(pic: 'assets/brand/192.png', maxH: 120, padding: 10, color: Colors.black54, func: () => refreshApp()),
                            const SizedBox(height: 8),
                            CheckSV.internetCheck(context)
                                ? Container(
                                    constraints: const BoxConstraints(maxWidth: 600),
                                    child: Card(
                                      color: Colors.black54,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: const BorderSide(color: Colors.white24, width: 1.5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(wel.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                            Text(brandName, style: TextStyle(fontSize: 26, color: AppColors.primarySwatch, fontWeight: FontWeight.bold)),
                                            const Divider(color: Colors.white24, height: 16, thickness: 1),
                                            const RefWg(),
                                            Visibility(
                                              visible: _.buttonWgView.value,
                                              child: Wrap(
                                                runSpacing: 5,
                                                alignment: WrapAlignment.center,
                                                runAlignment: WrapAlignment.center,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  Visibility(
                                                    visible: _.joinByMail.value,
                                                    child: ElevatedButton.icon(
                                                      icon: const Icon(Icons.email, color: Colors.white),
                                                      label: const Text('BY EMAIL', style: TextStyle(color: Colors.white)),
                                                      style: ElevatedButton.styleFrom(
                                                        shape: const StadiumBorder(),
                                                        padding: const EdgeInsets.symmetric(vertical: paddingDefault / 2, horizontal: paddingDefault),
                                                        primary: _.formView.value == 'email' ? AppColors.primaryLight : Colors.grey,
                                                      ),
                                                      onPressed: () => _.formView.value = 'email',
                                                    ),
                                                  ),
                                                  ElevatedButton.icon(
                                                    icon: const Icon(Icons.alternate_email, color: Colors.white),
                                                    label: const Text('By Google', style: TextStyle(color: Colors.white)),
                                                    style: ElevatedButton.styleFrom(
                                                      shape: const StadiumBorder(),
                                                      padding: const EdgeInsets.symmetric(vertical: paddingDefault / 2, horizontal: paddingDefault),
                                                      primary: _.formView.value == 'gg' ? AppColors.primaryLight : Colors.grey,
                                                    ),
                                                    onPressed: () => _.formView.value = 'gg',
                                                  ),
                                                  Visibility(
                                                    visible: _.joinByPhone.value,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5),
                                                      child: ElevatedButton.icon(
                                                        icon: const Icon(Icons.phone, color: Colors.white),
                                                        label: const Text('BY PHONE', style: TextStyle(color: Colors.white)),
                                                        style: ElevatedButton.styleFrom(
                                                          shape: const StadiumBorder(),
                                                          padding: const EdgeInsets.symmetric(vertical: paddingDefault / 2, horizontal: paddingDefault),
                                                          primary: _.formView.value == 'phone' ? AppColors.primaryLight : Colors.grey,
                                                        ),
                                                        onPressed: () => _.formView.value = 'phone',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            _.formView.value == 'phone'
                                                ? joinByPhoneForm(context)
                                                : _.formView.value == 'email'
                                                    ? joinByEmailLink(context, jCtr: _)
                                                    : joinByGoogle(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(notInternet, style: const TextStyle(color: Colors.white)),
                                      const SizedBox(height: 5),
                                      const Center(child: LinearProgressIndicator()),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: const CopyRightVersion(),
              ),
            );
          }
        });
  }

  Widget joinByGoogle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InkWell(child: Image.asset('assets/g_privacy.png'), onTap: () => signInWithGoogle()),
          const Divider(height: 16, color: Colors.white24, thickness: 1),
          Text(loginByGGAcc, style: const TextStyle(color: Colors.orange), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Wg.signInButton(pic: 'assets/google_icon.png', text: loginByGG, maxH: 40, color: AppColors.primaryLight, onTap: () => signInWithGoogle()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget joinByPhoneForm(BuildContext context) {
    final TextEditingController _phoneTextCtr = TextEditingController();
    final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
    _phoneTextCtr.text = LocalStore.storeRead(key: 'phone');
    String? _phoneNumber;
    String? _phoneCode;
    return Column(
      children: [
        Text(joinByPhone.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.white54)),
        const SizedBox(height: 8),
        Form(
          key: _formKeyPhone,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white12,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternationalPhoneNumberInput(
                  initialValue: PhoneNumber(isoCode: GetStorage().read('language') ?? 'US'),
                  textFieldController: _phoneTextCtr,
                  ignoreBlank: true,
                  formatInput: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, setSelectorButtonAsPrefixIcon: true, trailingSpace: false),
                  selectorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  // inputBorder: OutlineInputBorder(),
                  inputDecoration: InputDecoration(
                    hintText: yourPhone,
                    hintStyle: const TextStyle(color: Colors.white60),
                    helperStyle: TextStyle(color: AppColors.lightPurple),
                    // filled: true,
                    // fillColor: Colors.white24,
                    suffixIcon: InkWell(
                        child: const Icon(Icons.close, color: Colors.orangeAccent),
                        onTap: () {
                          LocalStore.storeRemove(key: 'phone');
                          _phoneTextCtr.text = '';
                        }),
                  ),
                  onSaved: (PhoneNumber number) {
                    _phoneCode = number.dialCode!;
                    _phoneNumber = number.phoneNumber!;
                    if (number.parseNumber().length > 3) {
                      if (number.parseNumber().substring(0, 1) == '0') {
                        _phoneNumber = _phoneCode! + number.parseNumber().replaceFirst('0', '');
                      }
                    }
                    // debugPrint(number.isoCode);
                    // debugPrint(_phoneNumber);
                    GetStorage().write('language', number.isoCode);
                  },
                  onInputChanged: (PhoneNumber number) {
                    _phoneCode = number.dialCode!;
                    _phoneNumber = number.phoneNumber!;
                    if (number.parseNumber().length > 3) {
                      if (number.parseNumber().substring(0, 1) == '0') {
                        _phoneNumber = _phoneCode! + number.parseNumber().replaceFirst('0', '');
                      }
                    }
                    // debugPrint(number.isoCode);
                    // debugPrint(_phoneNumber);
                    GetStorage().write('language', number.isoCode);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.fingerprint, color: Colors.white),
          label: Text(joinNow.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 5,
            primary: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
          ),
          onPressed: () async {
            // if (!_formKeyPhone.currentState!.validate()) {
            //   return;
            // }
            _formKeyPhone.currentState!.save();

            if (_phoneNumber! != '' && (_phoneNumber!.replaceAll(_phoneCode!, '').length >= 8)) {
              await signInWithPhoneNumberWeb(context, phone: _phoneNumber!, phoneCode: _phoneCode!);
            } else {
              Get.defaultDialog(
                middleText: notEmpty,
                textConfirm: ok,
                confirmTextColor: Colors.white,
                onConfirm: () => Get.back(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget joinByEmailLink(BuildContext context, {required JoinCtr jCtr}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return jCtr.waitEmailLink.value == false
        ? Form(
            key: _formKey,
            child: Column(
              children: [
                Text(joinByEmail.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.white54)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailLoginCtr,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    suffixIcon: InkWell(
                        child: const Icon(Icons.close, color: Colors.grey),
                        onTap: () {
                          LocalStore.storeRemove(key: 'email');
                          _emailLoginCtr.text = '';
                        }),
                    hintText: email,
                    hintStyle: const TextStyle(color: Colors.white60),
                    helperStyle: TextStyle(color: AppColors.lightPurple),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  validator: (String? value) {
                    if (value == '') {
                      return 'The field cannot be empty!';
                    } else if (!value!.trim().toLowerCase().isEmail) {
                      return 'Email invalidate!';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8),
                const Text('Sign-in with email link (passwordless)', style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: Text(join.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    elevation: 5,
                    primary: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                  ),
                  onPressed: () async {
                    hideKeyboard(context);
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    await joinByMailSendSignInLinkToEmail(email: _emailLoginCtr.text.trim().toLowerCase()).then((value) {
                      if (value) {
                        jCtr.waitEmailLink.value = true;
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.white,
                      // checkColor: Colors.green,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: controller.isChecked.value,
                      onChanged: (value) {
                        controller.isChecked.value = value;
                        // debugPrint('isChecked: ${_.isChecked.value}');
                      },
                    ),
                    Text(rememberAcc, style: TextStyle(color: AppColors.primaryLight)),
                  ],
                ),
              ],
            ),
          )
        : waitOpenLinkInEmail();
  }

  Widget waitOpenLinkInEmail() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset("assets/check-your-email.png"),
          const SizedBox(height: 16),
          const Text('Login link has been sent to your inbox:', style: TextStyle(color: Colors.orange), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('${LocalStore.storeRead(key: 'email')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Please check your mailbox and Click on the link to login! Thanks!', style: TextStyle(color: Colors.orange), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const Text('Action you need to take now:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Divider(height: 5, color: Colors.white24),
          Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white54),
                    Text(' 1 - Open your email: ${LocalStore.storeRead(key: 'email')}', style: const TextStyle(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.white54),
                    Text(' 2 - Click on the link in your email to login.', style: TextStyle(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: Colors.white24, thickness: 1),
          const Center(child: Text('IF YOU DO NOT RECEIVE EMAIL', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Use another account ->', style: TextStyle(color: Colors.white70, fontSize: 13)),
              TextButton(child: const Text("Change", style: TextStyle(color: Colors.white)), onPressed: () => controller.waitEmailLink.value = false),
            ],
          ),
        ],
      ),
    );
  }

  Widget otpSms(BuildContext context, String phone, String phoneCode, String verificationId) {
    final TextEditingController _smsController = TextEditingController();
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('OTP $confirm'.toUpperCase(), style: TextStyle(color: AppColors.primaryDeep)),
          Text('$plWaitSms:', style: TextStyle(color: AppColors.primaryDeep), textAlign: TextAlign.center),
          Text(phone, style: TextStyle(color: AppColors.primaryDeep, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Wg.countdownTimerOTP(
            onEnd: () {
              Get.back();
              _smsController.clear();
            },
          ),
          TextField(
            controller: _smsController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: '$enterOtp:',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: const TextStyle(color: Colors.black),
              hintText: 'eg: 36xxxx',
              filled: true,
              fillColor: Colors.black12,
              border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(cancel.toUpperCase()),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primarySwatch),
                onPressed: () async {
                  Get.back();
                  _smsController.clear();
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: Text(confirm.toUpperCase(), style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primaryColor),
                onPressed: () async {
                  if (_smsController.text == '') {
                    Get.defaultDialog(
                      middleText: '$notEmpty!',
                      textConfirm: ok,
                      confirmTextColor: Colors.white,
                      onConfirm: () => Get.back(),
                    );
                  } else {
                    Get.back();
                    confirmSignInWithPhoneNumberWeb(context, otpSms: _smsController.text, phoneCode: phoneCode, verificationId: verificationId);
                    _smsController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
