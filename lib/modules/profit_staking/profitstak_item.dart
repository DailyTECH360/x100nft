import 'package:flutter/material.dart';

import '../../data/utils.dart';
import '../../data/models/models.dart';

class ProfitStakItem extends StatelessWidget {
  final ProfitStakModel data;
  const ProfitStakItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0, left: 0.0, right: 0.0, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text('$day.${data.getDoneDay} '),
                Expanded(
                  child: Wg.timeWg(timeData: data.timeCreated!),
                ),
                _profitDay(),
              ],
            ),
            Row(
              children: [Expanded(child: _investPackName()), _investPack()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profitDay() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        data.profitDay! > 0 ? const Icon(Icons.add, size: 15) : const Text(''),
        Text(NumF.decimals(num: data.profitDay ?? 0), style: TextStyle(color: AppColors.primaryColor)),
        Wg.logoBoxCircle(pic: getLogoByWallet(data.symbol!), maxH: 30, padding: 3, colorBorder: Colors.black26, color: Colors.white30),
        // Text(data.symbol!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _investPackName() {
    return Row(
      children: [
        Text('$profitof: ', style: TextStyle(color: AppColors.primaryColor, fontSize: 11)),
        Text('${data.stakId}', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 10)),
      ],
    );
  }

  Widget _investPack() {
    return Text(data.profitDay! > 0 ? '$invest: ${NumF.decimals(num: data.stakAmount!)} ${data.symbol!}' : '${"of day"}: ${data.getDoneDay}}',
        style: const TextStyle(fontSize: 12, color: Colors.black87), overflow: TextOverflow.ellipsis);
  }
}
