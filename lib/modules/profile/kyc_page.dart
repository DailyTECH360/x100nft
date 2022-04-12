import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'kyc_ctr.dart';

class KycPage extends GetView<UserCtr> {
  const KycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(title: const Text('Account Verification')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: GetX<KycCtrST>(
                init: KycCtrST(),
                builder: (_) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text('ID Verification:', style: TextStyle(fontSize: 16, color: Colors.white54)),
                      const SizedBox(height: 8),
                      const Text('To secure your assets, we have to verify your identity. Please fill in correct information, it cannot be edited once verified.',
                          style: TextStyle(color: Colors.orange), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _.step.value == 1 ? AppColors.primaryLight : Colors.white30,
                                      border: Border.all(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
                                const SizedBox(height: 8),
                                const Text('Personal information', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _.step.value == 2 ? AppColors.primaryLight : Colors.white30,
                                      border: Border.all(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
                                const SizedBox(height: 8),
                                const Text('Proof of identity', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _.step.value == 3 ? AppColors.primaryLight : Colors.white30,
                                      border: Border.all(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
                                const SizedBox(height: 8),
                                const Text('Review', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Card(
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _.step.value == 1
                              ? step1(context, _)
                              : _.step.value == 2
                                  ? step2(context, _)
                                  : step3(context, _),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget step1(BuildContext context, KycCtrST ctr) {
    final TextEditingController _fullNameCtr = TextEditingController();
    final TextEditingController _countryCtr = TextEditingController();
    final TextEditingController _nationalIdCtr = TextEditingController();

    _fullNameCtr.text = UserCtr.to.userDB!.name!;
    _countryCtr.text = UserCtr.to.userDB!.country!;
    _nationalIdCtr.text = UserCtr.to.userDB!.personalID!;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          TextFormField(
            controller: _fullNameCtr,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.assignment_ind, color: Colors.white),
              hintText: 'Full Name',
              hintStyle: const TextStyle(color: Colors.white60),
              helperStyle: TextStyle(color: AppColors.lightPurple),
              filled: true,
              fillColor: Colors.white24,
            ),
            validator: (String? value) {
              if (value == '') {
                return 'The field cannot be empty!';
              } else if (value!.length < 6) {
                return 'Not Full Name format!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            controller: _countryCtr,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: CountryCodePicker(
                onChanged: (v) => _countryCtr.text = v.name!,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'US',
                favorite: const ['+84', 'VN', 'US', 'FR'],
                textStyle: const TextStyle(color: Colors.white),
                // optional. Shows only country name and flag
                showDropDownButton: true,
                showCountryOnly: true,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: true,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
              prefixIcon: const Icon(Icons.flag, color: Colors.white),
              hintText: "Choose country -->",
              hintStyle: const TextStyle(color: Colors.white60),
              helperStyle: TextStyle(color: AppColors.lightPurple),
              filled: true,
              fillColor: Colors.white24,
            ),
            validator: (String? value) {
              if (value == '') {
                return 'The field cannot be empty!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nationalIdCtr,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.recent_actors, color: Colors.white),
              hintText: "National ID Number/Passport Number",
              hintStyle: const TextStyle(color: Colors.white60),
              helperStyle: TextStyle(color: AppColors.lightPurple),
              filled: true,
              fillColor: Colors.white24,
            ),
            validator: (String? value) {
              if (value == '') {
                return 'The field cannot be empty!';
              } else if (value!.length < 9) {
                return 'Not ID Number format!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: Text('NEXT STEP'.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16)),
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
              await updateUserDB(
                uid: UserCtr.to.userDB!.uid!,
                data: {'name': _fullNameCtr.text, 'country': _countryCtr.text, 'personalID': _nationalIdCtr.text},
              );
              ctr.step.value = 2;
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget step2(BuildContext context, KycCtrST ctr) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('1. Please make sure that the photo is complete and clearly visible, in JPG, PNG, JPEG format.',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 13), textAlign: TextAlign.left),
            Text('2. Please take a photo of your ID Card. The photo should be bright and clear, and all corners of your document must be visible.',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 13), textAlign: TextAlign.left),
          ],
        ),
        const Divider(color: Colors.white30, height: 10, thickness: 1),
        const SizedBox(height: 16),
        const Text('ID Card Front Side:', style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
        const SizedBox(height: 8),
        Stack(
          alignment: !UserCtr.to.userDB!.picFrontIdUrl.isBlank! ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
          children: [
            UserCtr.to.userDB!.picFrontIdUrl.isBlank!
                ? Image.asset('assets/kyc/Front.jpg')
                : Image.network(!ctr.picFrontIdUrl.value.isBlank! ? ctr.picFrontIdUrl.value : UserCtr.to.userDB!.picFrontIdUrl!, fit: BoxFit.cover),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: Text(!UserCtr.to.userDB!.picFrontIdUrl.isBlank! ? 'Edit Image' : 'Upload Image'),
              style: ElevatedButton.styleFrom(elevation: 5, primary: Colors.orangeAccent),
              onPressed: () async {
                await ctr.imagePickerUpload('picFrontIdUrl');
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('ID Card Back Side:', style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
        const SizedBox(height: 8),
        Stack(
          alignment: !UserCtr.to.userDB!.picBehindIdUrl.isBlank! ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
          children: [
            UserCtr.to.userDB!.picBehindIdUrl.isBlank!
                ? Image.asset('assets/kyc/Behind.jpg')
                : Image.network(!ctr.picBehindIdUrl.value.isBlank! ? ctr.picBehindIdUrl.value : UserCtr.to.userDB!.picBehindIdUrl!, fit: BoxFit.fitWidth),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: Text(!UserCtr.to.userDB!.picBehindIdUrl.isBlank! ? 'Edit Image' : 'Upload Image'),
              style: ElevatedButton.styleFrom(elevation: 5, primary: Colors.orangeAccent),
              onPressed: () async {
                await ctr.imagePickerUpload('picBehindIdUrl');
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Selfie with your personnal paper:', style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
        const SizedBox(height: 8),
        Stack(
          alignment: !UserCtr.to.userDB!.picSelfIdUrl.isBlank! ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
          children: [
            UserCtr.to.userDB!.picSelfIdUrl.isBlank!
                ? Image.asset('assets/kyc/verify-selfie.png')
                : Image.network(!ctr.picSelfIdUrl.value.isBlank! ? ctr.picSelfIdUrl.value : UserCtr.to.userDB!.picSelfIdUrl!, fit: BoxFit.fitWidth),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: Text(!UserCtr.to.userDB!.picSelfIdUrl.isBlank! ? 'Edit Image' : 'Upload Image'),
              style: ElevatedButton.styleFrom(elevation: 5, primary: Colors.orangeAccent),
              onPressed: () async {
                await ctr.imagePickerUpload('picSelfIdUrl');
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          label: Text('$confirm KYC'.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 5,
            primary: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
          ),
          onPressed: () {
            if (!UserCtr.to.userDB!.picFrontIdUrl.isBlank! && !UserCtr.to.userDB!.picBehindIdUrl.isBlank! && !UserCtr.to.userDB!.picSelfIdUrl.isBlank!) {
              ctr.step.value = 3;
            } else {
              showTopSnackBar(context, const CustomSnackBar.error(message: 'Upload Image not done!'), additionalTopPadding: 80);
            }
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget step3(BuildContext context, KycCtrST ctr) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text('Successfully Submitted!', style: TextStyle(color: Colors.green, fontSize: 18), textAlign: TextAlign.center),
        const Text('We will review your documents and complete the process in 7 working days.', style: TextStyle(color: Colors.green, fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.done, color: Colors.white),
          label: Text('DONE'.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 5,
            primary: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
          ),
          onPressed: () async {
            await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'kyc': 'pending'});
            Get.back();
            // ctr.step.value = 1;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
