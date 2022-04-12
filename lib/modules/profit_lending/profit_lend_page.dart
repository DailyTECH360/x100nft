import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../data/models/models.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'profit_ctrst.dart';
import 'profit_item.dart';

class ProfitLendPage extends GetWidget<UserCtr> {
  final String id;
  final UserModel uData;
  const ProfitLendPage({Key? key, required this.uData, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(centerTitle: false, title: Wg.textDot(text: '$profit of: $id', before: 12, style: const TextStyle(fontSize: 12, color: Colors.white))),
      body: GetX<ProfitLendingCtrST>(
        init: Get.put(ProfitLendingCtrST()),
        initState: (_) {
          ProfitLendingCtrST.to.startGetST(uid: uData.uid!, id: id);
        },
        builder: (ctr) {
          if (ctr.profitByIdList.isNotEmpty && ctr.by.value != '') {
            dynamic sumA = ctr.sumAll(list: ctr.profitByIdList);
            return Column(
              children: [
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () => Get.find<ProfitLendingCtrST>().by.value = 'd',
                        label: Text('By day'.tr),
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primaryLight),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.filter_alt, color: Colors.white),
                        onPressed: () => Get.find<ProfitLendingCtrST>().by.value = 'w',
                        label: Text('By week'.tr),
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primaryLight),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text('#: ${sumA['total']} = ${NumF.decimals(num: sumA['amount'])}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 8),
                Expanded(
                  child: GroupedListView<ProfitModel, String>(
                    elements: ctr.profitByIdList,
                    order: GroupedListOrder.DESC,
                    groupBy: (element) => ctr.byDk(element).value,
                    floatingHeader: false,
                    useStickyGroupSeparators: true,
                    stickyHeaderBackgroundColor: AppColors.primaryColor,
                    groupHeaderBuilder: (bet) {
                      dynamic sumBy = ctr.sumBy(list: ctr.profitByIdList, by: bet);
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black26), color: Colors.white10),
                        child: Text('${ctr.toTextByFilter(bet).value}: #${sumBy['total']} = $symbold${NumF.decimals(num: sumBy['amount'])}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    },
                    itemComparator: (item1, item2) => item1.timeCreated!.compareTo(item2.timeCreated!),
                    itemBuilder: (_, data) => ProfitLendingItem(data: data),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Wg.noData());
          }
        },
      ),
    );
  }
}
