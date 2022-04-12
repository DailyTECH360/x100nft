import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/models/tokenprice_m.dart';
import '../../data/services/services.dart';
import '../../data/services/wg_global/num_page.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'swap_ctr.dart';

class SwapPage extends StatelessWidget {
  const SwapPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future wAmount(BuildContext context, String text) async {
      // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
      SwapCtr.to.amountFrom.value = double.parse(text == '' ? '0' : text);
      // debugPrint('aWAdd: $text');
    }

    onChFrom(WalletInfoModel? val) {
      debugPrint(val!.symbol);
      SwapCtr.to.ojFrom.value = val;
    }

    onChTo(WalletInfoModel? val) async {
      debugPrint(val!.symbol);
      SwapCtr.to.ojTo.value = val;
      TokenPricePk pri = await getTokenPricePanecakeApi(symbol: val.symbol!);
      SwapCtr.to.rateBnb.value = pri.data!.priceBnb!;
      SwapCtr.to.rateUsdt.value = pri.data!.priceUsd!;
    }

    return GetX<SwapCtr>(
        init: Get.put(SwapCtr()),
        builder: (_) {
          _.amountFromTextCtr.selection = TextSelection.fromPosition(TextPosition(offset: _.amountFromTextCtr.text.length));
          _.amountFromTextCtr.text = _.amountFrom.value.toString();
          return Container(
            decoration: const BoxDecoration(image: AppColors.bgImage2),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(title: Text(exchange)),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(swapSystem.toUpperCase(), style: TextStyle(color: AppColors.primaryLight, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(minWidth: 280, maxWidth: 600),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            border: Border.all(width: 1, color: Colors.white38),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              FormBuilderDropdown(
                                name: 'swapFrom',
                                isExpanded: false,
                                isDense: false,
                                iconSize: 40,
                                dropdownColor: Colors.white,
                                initialValue: _.ojFrom.value,
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                                items: wListFrom
                                    .map(
                                      (w) => DropdownMenuItem(
                                        value: w,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Wg.logoBoxCircle(
                                              pic: w.iconImage!,
                                              maxH: 50,
                                              colorBorder: Colors.black26,
                                              color: Colors.black12,
                                            ),
                                            Text(' ${w.symbol}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: onChFrom,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(16)), border: Border.all(width: 1, color: Colors.white38), gradient: AppColors.linearG5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$from:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Wg.textRowWg(
                                            title: '$balance:',
                                            text: NumF.decimals(num: getWalletBalance(SwapCtr.to.ojFrom.value.wallet!)),
                                            style: const TextStyle(color: Colors.black, fontSize: 14)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _.amountFromTextCtr,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              textAlignVertical: TextAlignVertical.center,
                                              onChanged: (value) => _.amountFrom.value = double.parse(value),
                                            ),
                                            onTap: () => Get.to(NumPage(getText: wAmount, initText: '0')),
                                          ),
                                        ),
                                        InkWell(child: const Icon(Icons.cancel, color: Colors.black38), onTap: () => _.amountFrom.value = 0),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryLight,
                                              border: Border.all(color: Colors.black26, width: 1),
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Text(max.toUpperCase(), style: TextStyle(color: AppColors.primaryDeep, fontSize: 13)),
                                          ),
                                          onTap: () => _.amountFrom.value = getWalletBalance(SwapCtr.to.ojFrom.value.wallet!).floor().toDouble(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: AppColors.primaryColor),
                                    onPressed: () {
                                      if (_.amountFrom.value >= 20) {
                                        _.amountFrom.value = _.amountFrom.value - 10;
                                      }
                                    },
                                  ),
                                  // IconButton(
                                  //   icon: Icon(Icons.swap_vert_circle, size: 30, color: AppColors.primaryColor),
                                  //   onPressed: () => _.swapSwitch(),
                                  // ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: AppColors.primaryColor),
                                    onPressed: () => _.amountFrom.value = _.amountFrom.value + 10,
                                  ),
                                ],
                              ),
                              FormBuilderDropdown(
                                name: 'swapTo',
                                isExpanded: false,
                                isDense: false,
                                iconSize: 40,
                                dropdownColor: Colors.white,
                                initialValue: _.ojTo.value,
                                validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                                items: wListTo
                                    .map(
                                      (w) => DropdownMenuItem(
                                        value: w,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Wg.logoBoxCircle(
                                              pic: w.iconImage!,
                                              maxH: 50,
                                              colorBorder: Colors.black26,
                                              color: Colors.black12,
                                            ),
                                            Text(' ${w.symbol}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: onChTo,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(16)), border: Border.all(width: 1, color: Colors.white38), gradient: AppColors.linearG4),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$to:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Wg.textRowWg(
                                            title: '$rate:',
                                            text: '${NumF.decimals(num: SwapCtr.to.rate.value)} $symbolAll',
                                            style: const TextStyle(color: Colors.black, fontSize: 14)),
                                        Wg.textRowWg(title: '$fee:', text: '${NumF.decimals(num: _.feeSwap.value)}%', style: const TextStyle(color: Colors.black, fontSize: 14))
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(NumF.decimals(num: _.amountTo.value), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        Text(_.ojTo.value.symbol!, style: const TextStyle(fontSize: 14, color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.multiple_stop),
                                label: Text(swapNow.toUpperCase()),
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30), shape: const StadiumBorder(), elevation: 5),
                                onPressed: () async {
                                  if (CheckSV.minCheck(context,
                                      dk: (_.amountFrom.value >= UserCtr.to.set!.minWithdraw!.toDouble()), min: UserCtr.to.set!.minWithdraw!.toDouble())) {
                                    if (CheckSV.balanceCheck(context, dk: (_.amountFrom.value <= getWalletBalance(SwapCtr.to.ojFrom.value.wallet!)))) {
                                      Get.defaultDialog(
                                          title: '$swapConfirm:',
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(swap),
                                              Text('${NumF.decimals(num: _.amountFrom.value)} ${_.ojFrom.value.symbol!}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 6),
                                              Text('$to ${NumF.decimals(num: _.amountTo.value)} ${_.ojTo.value.symbol!}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              Text('$rate = ${NumF.decimals(num: _.rate.value)}'),
                                              const SizedBox(height: 10),
                                              Text(sure.toUpperCase()),
                                            ],
                                          ),
                                          textConfirm: yes,
                                          confirmTextColor: Colors.white,
                                          buttonColor: AppColors.primaryColor,
                                          cancelTextColor: AppColors.primaryDeep,
                                          textCancel: no,
                                          onConfirm: () async {
                                            hideKeyboard(context);
                                            Get.back();
                                            await _.swapSave();
                                            showTopSnackBar(context, CustomSnackBar.success(message: '$swap: ${_.type}'));
                                            _.amountFromTextCtr.text = '10';
                                          });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
