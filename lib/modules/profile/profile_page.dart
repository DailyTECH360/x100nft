import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../../data/services/twofa_page.dart';
import 'qr_profile_widget.dart';

class ProfilePage extends GetView<UserCtr> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.linearG1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(myProfile)),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                child: Obx(() {
                  return Column(
                    children: [
                      Wg.sponWg(),
                      Wg.teamCountWg(),
                      Visibility(visible: controller.userDB!.refCode != null, child: const QrProfile()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderSwitch(
                          name: 'onPin',
                          title: Text('PIN SET (${controller.userDB!.pinSet == 'On' ? 'On' : 'Off'})', style: const TextStyle(color: Colors.white)),
                          activeColor: Colors.greenAccent,
                          initialValue: controller.userDB!.pinSet == 'On' ? true : false,
                          onChanged: (value) async {
                            if (value!) {
                              await updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'pinSet': 'On'});
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
                                    await updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'pin': matchedText});
                                    Navigator.pop(context);
                                  },
                                  footer: TextButton(
                                    child: Text(returnSetPin),
                                    onPressed: () => inputController.unsetConfirmed(),
                                  ),
                                );
                              }
                            } else {
                              await updateAnyField(coll: 'users', docId: UserCtr.to.userDB!.uid!, data: {'pinSet': 'Off', 'pin': ''});
                            }
                          },
                        ),
                      ),
                      const BankWidget(),
                      const Divider(color: Colors.white38, thickness: 1, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.settings, color: Colors.white70),
                            label: Text(menuTwoFa, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(primary: AppColors.primaryLight, shape: const StadiumBorder()),
                            onPressed: () {
                              Get.to(const Set2faPage());
                            },
                          ),
                          // const SizedBox(width: 5),
                          // Visibility(
                          //   visible: controller.userDB!.kyc != 'done' && controller.userDB!.kyc != 'pending',
                          //   child: ElevatedButton.icon(
                          //     icon: const Icon(Icons.fingerprint, color: Colors.white70),
                          //     label: const Text('KYC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          //     style: ElevatedButton.styleFrom(primary: AppColors.primaryLight, shape: const StadiumBorder()),
                          //     onPressed: () {
                          //       Get.to(const KycPage());
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      // const SizedBox(height: 20),
                      // Visibility(
                      //   visible: controller.userDB!.kyc == 'pending',
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: const [
                      //       SizedBox(height: 16),
                      //       Text('Submitted!',
                      //           style: TextStyle(color: Colors.orangeAccent, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      //       Text('We will review your documents and complete the process in 7 working days.',
                      //           style: TextStyle(color: Colors.orange, fontSize: 16), textAlign: TextAlign.center),
                      //       SizedBox(height: 8),
                      //       Text('Please wait!', style: TextStyle(color: Colors.greenAccent, fontSize: 16), textAlign: TextAlign.center),
                      //       SizedBox(height: 16),
                      //     ],
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: controller.userDB!.kyc == 'done',
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: const [
                      //       SizedBox(height: 16),
                      //       Text('KYC\nAccount Verification\nSuccessfully!',
                      //           style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      //       SizedBox(height: 8),
                      //       Icon(Icons.check_circle, color: Colors.green, size: 120),
                      //       SizedBox(height: 16),
                      //     ],
                      //   ),
                      // ),
                    ],
                  );
                }),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
