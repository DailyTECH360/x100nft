import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/models/models.dart';
import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

class AgentItem extends StatelessWidget {
  final UserModel userData;
  const AgentItem({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _buildListItem(context, userData),
      onTap: () => numEditPopUp(context, initNum: '${userData.comAgent!}'),
    );
  }

  numEditPopUp(BuildContext context, {required String initNum}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textCtr = TextEditingController();
    _textCtr.text = initNum;
    PopUp.popUpWg(
      context,
      wg: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _textCtr,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // keyboardType: const TextInputType.numberWithOptions(decimal: true),
              // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                labelText: enterNum,
                hintText: '$maxSet: ${UserCtr.to.set!.maxAgent!}',
                labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
              validator: (String? value) {
                if (value == '') {
                  return "The field cannot be empty!";
                }
                if (int.parse(value!) < 0) {
                  return "The Agent % must >= 0!";
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text("${setAg.toUpperCase()} %"),
                onPressed: () async {
                  hideKeyboard(context);
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();

                  if (_textCtr.text != initNum) {
                    Get.back();
                    int numSet = int.parse(_textCtr.text);
                    if (numSet < UserCtr.to.set!.maxAgent! && numSet < UserCtr.to.userDB!.comAgent! && numSet >= userData.comAgentF1Max!) {
                      await addDocToCollDynamic(coll: 'agents', data: {
                        'comAgent': numSet,
                        'status': 'pending',
                        'uid': UserCtr.to.userDB!.uid!,
                        'uidF1': userData.uid!,
                        'uidComMax': UserCtr.to.userDB!.comAgent,
                        'uidComF1Max': UserCtr.to.userDB!.comAgentF1Max,
                        'timestamp': Timestamp.now(),
                        'timeConfirm': null,
                        'byAdmin': null,
                      });
                      // await updateUserDB(uid: userData.uid!, data: {'comAgent': numSet});
                      showTopSnackBar(context, CustomSnackBar.success(message: '$setAg $numSet% send admin is DONE!'), additionalTopPadding: 60, onTap: () => Get.back());
                    } else {
                      showTopSnackBar(context,
                          CustomSnackBar.error(message: 'The Agent % must < ${UserCtr.to.set!.maxAgent!}% & < ${UserCtr.to.userDB!.comAgent!}% & >= ${userData.comAgentF1Max!}!'));
                    }
                    _textCtr.text = '';
                  } else {
                    Get.back();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

Widget _buildListItem(BuildContext context, UserModel data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
    child: Container(
      decoration: BoxDecoration(color: Colors.white12, border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: data.comAgent! > 0 ? Colors.green : Colors.white24,
              child: data.comAgent! > 0
                  ? Text('${data.comAgent}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))
                  : const Icon(Icons.person, size: 35, color: Colors.white),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Wg.textDot(text: data.name!, before: 5, after: 5, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Visibility(visible: data.comAgent! > 0, child: Text('(${data.comAgent}%)', style: TextStyle(color: AppColors.primaryLight))),
                    ],
                  ),
                  Wg.textDot(text: data.phone! != '' ? data.phone! : data.email!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  Row(
                    children: [
                      Text('$joinTime: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(TimeF.dateToSt(date: data.timeCreated!.toDate()), style: const TextStyle(color: Colors.white60, fontSize: 13), overflow: TextOverflow.clip),
                    ],
                  ),
                  Row(
                    children: [
                      Wg.textRowWg(title: 'F1:', text: '${data.teamF1}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(width: 5),
                      Wg.textRowWg(title: '$total:', text: '${data.teamGen}', style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wg.textRowWg(title: 'W:', text: NumF.decimals(num: data.wUsd ?? 0), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'V:', text: NumF.decimals(num: data.volumeMe!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'Pro:', text: NumF.decimals(num: data.wProfitTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
                Wg.textRowWg(title: 'Com:', text: NumF.decimals(num: data.wComTotal!), style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
