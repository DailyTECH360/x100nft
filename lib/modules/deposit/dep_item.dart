import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/models.dart';
import '../../data/utils.dart';

class DepItem extends StatelessWidget {
  final DepModel data;
  const DepItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: [Expanded(child: Wg.timeToDateWidget(timeData: Timestamp.fromMillisecondsSinceEpoch(data.timestamp!))), _status(), _amount()],
            ),
            _type(),
          ],
        ),
      ),
    );
  }

  Widget _status() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        border: Border.all(color: Colors.black26),
        color: data.status == 0 ? Colors.deepOrange : Colors.green,
      ),
      child: Text(data.status == 1 ? "done" : "pending...",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          )),
    );
  }

  Widget _amount() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            NumF.decimals(num: data.amount ?? 0),
            style: TextStyle(color: data.amount! < 0 ? AppColors.pieColors[4] : AppColors.pieColors[2], fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(symbolAll, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  ///Build Transfer Widget
  Widget _type() {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('${data.tokenName} Deposit', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black), textAlign: TextAlign.left),
          ),
          Visibility(
            visible: data.status! == 1 && data.txhash!.isNotEmpty,
            child: Row(
              children: [
                Wg.textDot(text: 'Tx: ${data.txhash!}', before: 9, after: 3, style: const TextStyle(color: Colors.black87)),
                InkWell(
                  child: const Icon(Icons.visibility, color: Colors.black, size: 18),
                  onTap: () async {
                    await launch('${getScanHashLink(data.tokenSymbol!)}${data.txhash!}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
