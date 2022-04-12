import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../../data/utils.dart';

class ComItem extends StatelessWidget {
  final CommissionModel? data;
  const ComItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0, left: 0.0, right: 0.0, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Wg.timeWg(timeData: data!.timeCreated!), _amount()],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [_typeNote(), _from()],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _amount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        data!.amount! > 0 ? const Icon(Icons.add, size: 15) : const Text(''),
        Text(
          NumF.decimals(num: data!.amount!),
          style: TextStyle(color: data!.amount! > 0 ? AppColors.primaryColor : Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Visibility(
            visible: data!.type! != 'Convert to wallet',
            child: Text("/ ${NumF.decimals(num: data!.fromVolume!)}", style: TextStyle(color: AppColors.primaryColor))),
        Text(symbolAll, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Widget _typeNote() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Visibility(
  //           visible: data!.type!.isNotEmpty,
  //           child: Text(data!.type!, style: TextStyle(color: AppColors.primaryColor, fontSize: 11), overflow: TextOverflow.ellipsis)),
  //       Visibility(
  //           visible: data!.note!.isNotEmpty,
  //           child: Text(data!.note!, style: TextStyle(color: AppColors.primaryColor, fontSize: 11), overflow: TextOverflow.ellipsis)),
  //     ],
  //   );
  // }

  // Widget _from() {
  //   return (data!.type! == 'Convert to wallet')
  //       ? Wg.textRowWg(
  //           title: 'To:', text: '${data!.fromPhone != '' ? data!.fromPhone : data!.uid}', style: const TextStyle(fontSize: 12, color: Colors.black54))
  //       : Row(
  //           children: [
  //             Text('Form: F${data!.gen!} - ', style: const TextStyle(fontSize: 12, color: Colors.black87)),
  //             Wg.textDot(
  //               before: 3,
  //               after: 3,
  //               text: '${data!.fromName != '' ? data!.fromName : data!.fromUid}',
  //               style: const TextStyle(fontSize: 12, color: Colors.black87),
  //             ),
  //           ],
  //         );
  // }
}
