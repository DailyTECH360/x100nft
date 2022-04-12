import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../../user_ctr.dart';
import '../../utils.dart';
import '../services.dart';
// import 'package:local_auth/local_auth.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Example',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const ScreenLockPage(),
//     );
//   }
// }

class ScreenLockPage extends StatefulWidget {
  const ScreenLockPage({Key? key}) : super(key: key);

  @override
  _ScreenLockPageState createState() => _ScreenLockPageState();
}

class _ScreenLockPageState extends State<ScreenLockPage> {
  // Future<void> localAuth(BuildContext context) async {
  //   final localAuth = LocalAuthentication();
  //   final didAuthenticate = await localAuth.authenticate(
  //     localizedReason: 'Please authenticate',
  //     biometricOnly: true,
  //   );
  //   if (didAuthenticate) {
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String myPin = LocalStore.storeRead(key: '${UserCtr.to.userAuth!.uid}_Pin');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen Lock'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Manualy open'),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => ScreenLock(correctString: myPin),
              ),
            ),
            ElevatedButton(
              child: const Text('Not cancelable'),
              onPressed: () => screenLock<void>(
                title: HeadingTitle(text: passcode),
                confirmTitle: HeadingTitle(text: passcodeConfirm),
                context: context,
                correctString: myPin,
                canCancel: false,
              ),
            ),
            ElevatedButton(
              child: const Text('Confirm mode'),
              onPressed: () {
                // Xác định nó để kiểm soát trạng thái xác nhận với các sự kiện riêng của mình.
                final inputController = InputController();
                screenLock<void>(
                  title: HeadingTitle(text: passcode),
                  confirmTitle: HeadingTitle(text: passcodeConfirm),
                  context: context,
                  correctString: '',
                  confirmation: true,
                  inputController: inputController,
                  didConfirmed: (matchedText) {
                    debugPrint(matchedText);
                  },
                  footer: TextButton(
                    child: const Text('Return enter mode.'),
                    onPressed: () {
                      // Phát hành trạng thái xác nhận và trở về trạng thái đầu vào ban đầu.
                      inputController.unsetConfirmed();
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Using footer'),
              onPressed: () => screenLock<void>(
                title: HeadingTitle(text: passcode),
                confirmTitle: HeadingTitle(text: passcodeConfirm),
                context: context,
                correctString: '123456',
                digits: '123456'.length,
                canCancel: false,
                footer: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                    child: Text(cancel),
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.transparent),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Not blur'),
              onPressed: () => screenLock<void>(
                title: HeadingTitle(text: passcode),
                confirmTitle: HeadingTitle(text: passcodeConfirm),
                context: context,
                correctString: myPin,
                withBlur: false,
                screenLockConfig: const ScreenLockConfig(
                  /// If you don't want it to be transparent, override the config
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Next page with unlock'),
              onPressed: () => screenLock<void>(
                title: HeadingTitle(text: passcode),
                confirmTitle: HeadingTitle(text: passcodeConfirm),
                context: context,
                correctString: myPin,
                didUnlocked: () {
                  Navigator.pop(context);
                  NextPage.show(context);
                },
              ),
            ),
            ElevatedButton(
              child: const Text('Delay next retry'),
              onPressed: () => screenLock<void>(
                title: HeadingTitle(text: passcode),
                confirmTitle: HeadingTitle(text: passcodeConfirm),
                context: context,
                correctString: myPin,
                maxRetries: 2,
                retryDelay: const Duration(seconds: 3),
                delayChild: const Center(
                  child: Text('Cannot be entered temporarily because it failed the specified number of times.', softWrap: true),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Customize styles'),
              onPressed: () {
                screenLock<void>(
                  context: context,
                  title: const Text('change title'),
                  confirmTitle: const Text('change confirm title'),
                  correctString: '',
                  confirmation: true,
                  screenLockConfig: const ScreenLockConfig(
                    backgroundColor: Colors.deepOrange,
                  ),
                  secretsConfig: SecretsConfig(
                    spacing: 15, // or spacingRatio
                    padding: const EdgeInsets.all(40),
                    secretConfig: SecretConfig(
                      borderColor: Colors.amber,
                      borderSize: 2.0,
                      disabledColor: Colors.black,
                      enabledColor: Colors.amber,
                      height: 15,
                      width: 15,
                      build: (context, {required config, required enabled}) {
                        return SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: enabled ? config.enabledColor : config.disabledColor,
                              border: Border.all(
                                width: config.borderSize,
                                color: config.borderColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            width: config.width,
                            height: config.height,
                          ),
                          width: config.width,
                          height: config.height,
                        );
                      },
                    ),
                  ),
                  inputButtonConfig: InputButtonConfig(
                      textStyle: InputButtonConfig.getDefaultTextStyle(context).copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                      buttonStyle: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.deepOrange,
                      ),
                      displayStrings: ['零', '壱', '弐', '参', '肆', '伍', '陸', '質', '捌', '玖']),
                  cancelButton: const Icon(Icons.close),
                  deleteButton: const Icon(Icons.delete),
                );
              },
            ),
            // ElevatedButton(
            //   onPressed: () => screenLock<void>(
            //     context: context,
            //     correctString: myPin,
            //     customizedButtonChild: const Icon(
            //       Icons.fingerprint,
            //     ),
            //     customizedButtonTap: () async {
            //       await localAuth(context);
            //     },
            //     didOpened: () async {
            //       await localAuth(context);
            //     },
            //   ),
            //   child: const Text(
            //     'use local_auth \n(Show local_auth when opened)',
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  static show(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NextPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
    );
  }
}
