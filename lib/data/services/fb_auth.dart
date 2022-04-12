import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:universal_html/html.dart';
import '../../intro/join/join.dart';
import '../models/models.dart';
import '../user_ctr.dart';
import '../utils.dart';
import 'services.dart';

AuthResultStatus? statusAuth;
final FirebaseAuth _auth = FirebaseAuth.instance;

//---------------------------------JOIN BY EMAIL Address:
Future<void> createUserByAddress(String address) async {
  Loading.show(text: 'Sign-In...');
  String emailCreate = '${address.toLowerCase()}@pas.com';
  String password = 'lock@lock${address.toLowerCase()}';

  await _auth.createUserWithEmailAndPassword(email: emailCreate, password: password).then((_authResult) async {
    await _auth.currentUser!.reload();
    debugPrint('currentUser: ${stringDot(text: _auth.currentUser!.uid)}');
    if (_authResult.user != null) {
      await _auth.currentUser!.updateDisplayName(address);
      //create user in DB
      await _auth.currentUser!.reload();
      debugPrint('With refCode: ${LocalStore.storeRead(key: 'spon')}');
      String myIp = await getMyIp();
      UserModel _user = UserModel(
        uid: _authResult.user!.uid,
        refCode: address.toLowerCase(),
        sponRefCode: LocalStore.storeRead(key: 'spon'),
        name: address,
        email: _authResult.user!.email,
        wUsd: 0,
        wCom: 0,
        wComTotal: 0,
        volumeMe: 0,
        timeCreated: now,
        ipJoin: myIp,
      );
      await createNewUserDB(uid: _authResult.user!.uid, data: _user.toJson());
      UserCtr.to.streamGetUserDB(uid: _auth.currentUser!.uid);
      addDocToCollDynamic(coll: 'ips', data: {'ip': myIp, 'timeNow': now, 'uid': _auth.currentUser!.uid, 'address': address.toLowerCase()});
      Loading.hide();
      LocalStore.storeSaveEmail(email: emailCreate);
      LocalStore.storeRemove(key: 'spon');
      statusAuth = AuthResultStatus.successful;
    }
  }).catchError((e) async {
    Loading.hide();
    debugPrint(e.code);
    if (e.code == 'email-already-in-use') {
      await loginByAddress(address: address);
    }
    // statusAuth = AuthExceptionHandler.handleException(e);
    // Get.snackbar("Error creating Account", e.toString(), snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
  });
}

Future<void> loginByAddress({required String address}) async {
  Loading.show(text: 'Login...', textSub: '$notCloseApp!');
  String emailCreate = '${address.toLowerCase()}@pas.com';
  String password = 'lock@lock${address.toLowerCase()}';
  await _auth.signInWithEmailAndPassword(email: emailCreate, password: password).then((value) async {
    await _auth.currentUser!.reload();
    debugPrint('currentUser login: ${stringDot(text: _auth.currentUser!.uid)}');
    LocalStore.storeSaveEmail(email: emailCreate);
    Loading.hide();
    statusAuth = AuthResultStatus.successful;
    UserCtr.to.streamGetUserDB(uid: _auth.currentUser!.uid);
  }).catchError((e) async {
    LocalStore.storeSaveEmail(email: emailCreate);
    Loading.hide();
    debugPrint(e);
    debugPrint(e.code);
    if (e.code == 'user-not-found') {
      await createUserByAddress(address);
    }
    // statusAuth = AuthExceptionHandler.handleException(e);
  });
}

// JOIN BY PHONE ------------------ WEB;
Future<void> signInWithPhoneNumberWeb(BuildContext context, {required String phone, required String phoneCode}) async {
  Loading.show(text: 'Phone verify...', textSub: phone);
  try {
    debugPrint('Phone: $phone');
    _auth.setLanguageCode('vi');
    ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
      phone,
      RecaptchaVerifier(
        onSuccess: () => debugPrint('reCAPTCHA Completed!'),
        onError: (FirebaseAuthException e) => debugPrint('$e'),
        onExpired: () => debugPrint('reCAPTCHA Expired!'),
      ),
    );
    Loading.hide();
    String _verificationId = confirmationResult.verificationId;
    statusAuth = AuthResultStatus.successful;
    PopUp.popUpWg(context, wg: JoinPage().otpSms(context, phone, phoneCode, _verificationId));
  } catch (e) {
    Loading.hide();
    statusAuth = AuthExceptionHandler.handleException(e);
  }
}

Future<void> confirmSignInWithPhoneNumberWeb(BuildContext context, {required String otpSms, required String phoneCode, required String verificationId}) async {
  Loading.show(text: 'SignIn by phone...', textSub: '$notCloseApp!');
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpSms);
    final _authResult = await _auth.signInWithCredential(credential);
    String _phone = _authResult.user!.phoneNumber!.replaceAll(phoneCode, '0');
    String _name = _authResult.user!.phoneNumber!.substring(_authResult.user!.phoneNumber!.length - 4, _authResult.user!.phoneNumber!.length);
    var _refCode = creatRefCodeUUid();
    String myIp = await getMyIp();
    if (_authResult.additionalUserInfo!.isNewUser) {
      // debugPrint('authResult - uid: ${stringDot(text: _authResult.user!.uid)}');
      // debugPrint('PhoneCode: $phoneCode');
      // debugPrint('phoneNumber: $_phone');
      // debugPrint('Name Auto gen: $_name');
      // debugPrint('RefCode gen: $_refCode');
      await createNewUserDB(uid: _authResult.user!.uid, data: {
        'name': _name,
        'phone': _phone,
        'phoneCode': phoneCode,
        'sponRefCode': LocalStore.storeRead(key: 'spon').toLowerCase(),
        'refCode': _refCode.toLowerCase(),
        'uidSpon': '',
        'timeCreated': now,
        'ipJoin': myIp,
      });
      LocalStore.storeRemove(key: 'spon');
      addDocToCollDynamic(coll: 'ips', data: {'ip': myIp, 'timeNow': now, 'uid': _auth.currentUser!.uid, 'phone': _authResult.user!.phoneNumber});
    }
    UserCtr.to.streamGetUserDB(uid: _auth.currentUser!.uid);
    Loading.hide();
    LocalStore.storeSavePhone(phone: _phone);
    LocalStore.storeSaveKey(key: 'logBy', value: 'phone');
    statusAuth = AuthResultStatus.successful;
  } catch (e) {
    Loading.hide();
    statusAuth = AuthExceptionHandler.handleException(e);
  }
}

//---------------------------------JOIN BY LINKEMAIL:
Future<bool> joinByMailSendSignInLinkToEmail({required String email}) async {
  var acs = ActionCodeSettings(
    // URL you want to redirect back to. The domain (www.example.com) for this
    // URL must be whitelisted in the Firebase Console.
    // Cần kèm theo param email để ở các trình duyệt # đều đăng nhập được
    url: '${LocalStore.storeRead(key: 'url')}?email=$email',
    handleCodeInApp: true, // This must be true
    // dynamicLinkDomain: LocalStore.storeRead(key: 'url'),
  );
  _auth.setLanguageCode('vi');
  return await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs).then((value) {
    LocalStore.storeSaveKey(key: 'email', value: email.trim());
    debugPrint('Successfully sent email verification');
    statusAuth = AuthResultStatus.successful;
    return true;
  }).catchError((onError) {
    debugPrint('Error sending email verification $onError');
    statusAuth = AuthExceptionHandler.handleException(onError);
    return false;
  });
}

Future<void> confirmJoinByMail() async {
  // Confirm the link is a sign-in with email link.
  // Retrieve the email from wherever you stored it
  String emailAuth = LocalStore.storeRead(key: 'email');
  String actLinkOfEmail = LocalStore.storeRead(key: 'actLink');
  debugPrint('actLink: $actLinkOfEmail');
  if (actLinkOfEmail.isNotEmpty) {
    debugPrint('Run confirmJoinByMail');
    if (_auth.isSignInWithEmailLink(actLinkOfEmail)) {
      debugPrint('Run signInWithEmailLink');
      // The client SDK will parse the code from the link for you.
      _auth.signInWithEmailLink(email: emailAuth, emailLink: actLinkOfEmail).then((value) async {
        // You can access the new user via value.user
        // Additional user info profile *not* available via:
        // value.additionalUserInfo.profile == null

        // You can check if the user is new or existing:
        debugPrint('Successfully signed in with emaillink! uid: ${value.user!.uid}');
        if (value.additionalUserInfo!.isNewUser) {
          String myIp = await getMyIp();
          var _refCode = creatRefCodeUUid();
          UserModel _newUser = UserModel(
            uid: value.user!.uid,
            name: value.user!.email!.split('@').first,
            email: value.user!.email,
            refCode: _refCode,
            sponRefCode: LocalStore.storeRead(key: 'spon'),
            timeCreated: now,
            ipJoin: myIp,
          );
          await createNewUserDB(uid: value.user!.uid, data: _newUser.toJson());
          LocalStore.storeRemove(key: 'spon');
          addDocToCollDynamic(coll: 'ips', data: {'ip': myIp, 'timeNow': now, 'uid': _auth.currentUser!.uid, 'email': value.user!.email});
        }
        UserCtr.to.streamGetUserDB(uid: _auth.currentUser!.uid);
        LocalStore.storeRemove(key: 'email');
        LocalStore.storeRemove(key: 'actLink');
        statusAuth = AuthResultStatus.successful;
      }).catchError((onError) {
        LocalStore.storeRemove(key: 'actLink');
        debugPrint('Error signing in with email link $onError');
        statusAuth = AuthExceptionHandler.handleException(onError);
      });
    } else {
      LocalStore.storeRemove(key: 'actLink');
      debugPrint('actLinkOfEmail Not True');
    }
  }
}

//---------------------------------JOIN BY GoogleACC:
Future<void> signInWithGoogle() async {
  try {
    UserCredential userCredential;
    if (kIsWeb) {
      // Create a new provider
      var googleProvider = GoogleAuthProvider();
      // GoogleAuthProvider googleProvider = GoogleAuthProvider();
      // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      userCredential = await _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
    }

    LocalStore.storeSaveKey(key: 'email', value: userCredential.user!.email!);
    if (userCredential.additionalUserInfo!.isNewUser) {
      String myIp = await getMyIp();
      var _refCode = creatRefCodeUUid();
      UserModel _newUser = UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.email!.split('@').first,
        email: userCredential.user!.email,
        refCode: _refCode,
        sponRefCode: LocalStore.storeRead(key: 'spon'),
        timeCreated: now,
        ipJoin: myIp,
      );
      await createNewUserDB(uid: userCredential.user!.uid, data: _newUser.toJson());
      LocalStore.storeRemove(key: 'spon');
      addDocToCollDynamic(coll: 'ips', data: {'ip': myIp, 'timeNow': now, 'uid': _auth.currentUser!.uid, 'email': userCredential.user!.email});
    }
    UserCtr.to.streamGetUserDB(uid: _auth.currentUser!.uid);
    debugPrint('Sign In ${stringDot(text: userCredential.user!.uid)} with Google');
  } catch (e) {
    debugPrint('$e');
    debugPrint('Failed to sign in with Google: $e');
    statusAuth = AuthExceptionHandler.handleException(e);
  }
}
//-----------------------------------------------------

bool? checkPhoneProvider(UserCtr _) {
  bool? check;
  for (var element in _.userAuth!.providerData) {
    if (element.providerId == 'phone') {
      check = true;
    } else {
      check = false;
    }
  }
  return check;
}

String checkRefLink() {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  // ------------------------------------------------
  String partUrl = uri.path.replaceFirst(',', '').replaceAll('%23', '#');
  String rootLink = '${partUrl.split('#/').first}#/'.toLowerCase();
  debugPrint('rootLink: $rootLink');
  LocalStore.storeSaveKey(key: 'url', value: rootLink);

  var ref = params['ref'];
  if (ref != null) {
    debugPrint('Ref = ${stringDot(text: ref)}');
    if (ref.length >= 6) {
      LocalStore.storeSaveKey(key: 'ref', value: ref);
      LocalStore.storeSponRefCode(refCodeSpon: ref);
      return ref;
    } else {
      return '';
    }
  } else {
    return '';
  }

  //  /?ref=6666666666 /?ref=$888888888&lang=en
  // var _spon = Get.routing.current.split('?ref=').last.split('&').first;
  // debugPrint('RefCode by routing: $_spon');
}

void getActLink() {
  // Get the code from link in the email:
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  // ------------------------------------------------
  String mode = params['mode'] ?? '';
  String oobCode = params['oobCode'] ?? '';
  LocalStore.storeSaveKey(key: 'mode', value: mode);
  LocalStore.storeSaveKey(key: 'oobCode', value: oobCode);
  if (mode.length >= 3 && oobCode.length >= 3) {
    debugPrint("mode: $mode");
    debugPrint("oobCode: $oobCode");
  }

  String? email = params['email'] ?? '';
  if (email.length >= 8) {
    debugPrint("email: $email");
    LocalStore.storeSaveKey(key: 'email', value: email.trim());
  }

  if (mode == 'signIn') {
    LocalStore.storeSaveKey(key: 'actLink', value: window.location.href);
    confirmJoinByMail();
  }
}

String checkRefOfUid({required String uid}) {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  // ------------------------------------------------
  String partUrl = uri.path.replaceFirst(',', '').replaceAll('%23', '#');
  String rootLink = '${partUrl.split('/#/').first}/#/'.toLowerCase();
  LocalStore.storeSaveKey(key: 'url', value: rootLink);
  // debugPrint('URL Domain only: $rootLink');

  var ref = params['ref'];
  if (ref != null) {
    if (ref.length >= 6) {
      LocalStore.storeSaveKey(key: uid.toLowerCase(), value: ref.toLowerCase());
      LocalStore.storeSponRefCode(refCodeSpon: ref.toLowerCase());
      return ref.toLowerCase();
    } else {
      return '';
    }
  } else {
    return '';
  }
}

void checkLinkAndRefreshApp() {
  var uri = Uri.dataFromString(window.location.href);
  var partUrl = uri.path.replaceFirst(',', '').replaceAll('%23', '#');
  // debugPrint('URL path: ${uri.path}');
  debugPrint('URL path: $partUrl');
  if (partUrl != LocalStore.storeRead(key: 'url')) {
    Get.toNamed('/');
  }
}

//-------------------------------- REF OK --------------------------------//
Future<UserModel?> linkSPON(BuildContext context, {required String sponCode, required UserModel uDB}) async {
  debugPrint('Link SPON Run: refSpon: ${stringDot(text: sponCode)}');
  // debugPrint('Link SPON Run: refSpon:$sponCode,  refCode: ${uDB.refCode!}, uid: ${uDB.uid!}, Name: ${uDB.name!}, Email: ${uDB.email!}');
  if (sponCode.length > 6 && uDB.refCode!.length > 6) {
    if (CheckSV.yourselfSponCheck(context, dk: sponCode.toLowerCase() != uDB.refCode!.toLowerCase())) {
      UserModel? uDataSponFind = await findFirstUser(by: sponCode.toLowerCase());
      if (uDataSponFind != null && uDataSponFind.uidSpon!.length >= 3) {
        if (CheckSV.checkSponSameMe(context, dk: uDataSponFind.uidSpon != uDB.uid)) {
          await updateUserDB(uid: uDB.uid!, data: {
            'uidSpon': uDataSponFind.uid,
            'role': (uDataSponFind.role == 'T' || uDataSponFind.role == 'dev') ? 'T' : '',
          });
          debugPrint('Link SPON = ${stringDot(text: uDataSponFind.uid!)}: done!');
          return uDataSponFind;
        } else {
          return null;
        }
      } else {
        LocalStore.storeRemove(key: 'spon');
        updateUserDB(uid: uDB.uid!, data: {'sponRefCode': ''});
        showTopSnackBar(context, const CustomSnackBar.error(message: 'Sponsor user is not found!'));
        return null;
      }
    } else {
      return null;
    }
  } else {
    debugPrint('Link SPON No: ${uDB.refCode!}');
    return null;
  }
}

String getRefFromSpon() {
  UserModel? userDB = UserCtr.to.userDB;
  String refSpon = '';
  if (userDB != null) {
    refSpon = ((userDB.sponRefCode!.length >= 6) ? userDB.sponRefCode! : ((LocalStore.storeRead(key: 'spon').length >= 6) ? LocalStore.storeRead(key: 'spon') : ''));
  } else {
    refSpon = ((LocalStore.storeRead(key: 'spon').length >= 6) ? LocalStore.storeRead(key: 'spon') : '');
  }
  return refSpon;
}

Future<void> funcREF(BuildContext context, {required UserModel userDB}) async {
  if (userDB.uidSpon!.length < 3) {
    debugPrint('Run funcREF by: ${stringDot(text: getRefFromSpon())}');
    if (getRefFromSpon().length >= 6) {
      await linkSPON(context, sponCode: getRefFromSpon(), uDB: userDB);
    } else {
      debugPrint('No reflink');
    }
  } else {
    debugPrint(no);
  }
}

Future<void> adminAddSponAndPA(BuildContext context, {required String sponCode, required String paRefCode, required String uid}) async {
  if (paRefCode != 'TOP' && sponCode != 'TOP') {
    UserModel? uDataSponFind = await findFirstUser(by: sponCode.toLowerCase());
    UserModel? uDataPaFind = await findFirstUser(by: paRefCode.toLowerCase());
    if (uDataSponFind != null) {
      if (uDataPaFind != null) {
        debugPrint('uDataSponFind.setSide = ${uDataSponFind.setSide}');
        //
        if (uDataSponFind.setSide != '') {
          updateUserDB(uid: uid, data: {
            'uidSpon': uDataSponFind.uid,
            'uidParent': uDataPaFind.uid,
            'isLeft': (uDataPaFind.setSide == 'L') ? true : false,
            'setSide': (uDataPaFind.setSide == 'L') ? 'L' : 'R',
          }).whenComplete(() {
            debugPrint('setSide = ${uDataPaFind.setSide}');
            Get.snackbar('Congratulations', 'Your Sponsor & Pa has been updated!', backgroundColor: Colors.white70);
          });
        }
      } else {
        showTopSnackBar(context, const CustomSnackBar.error(message: 'PA user is not found!'));
      }
    } else {
      showTopSnackBar(context, const CustomSnackBar.error(message: 'Sponsor user is not found!'));
    }
  } else {
    updateUserDB(uid: uid, data: {
      'uidSpon': 'TOP',
      'uidParent': 'TOP',
      'isLeft': true,
    }).whenComplete(() {
      Get.snackbar('Congratulations', 'Your Sponsor & Pa = TOP has been updated!', backgroundColor: Colors.white70);
    });
  }
}
//-------------------------------- REF OK --------------------------------//
