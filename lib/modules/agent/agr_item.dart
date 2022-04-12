import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../data/utils.dart';

class AgentRItem extends StatelessWidget {
  final AgentRModel data;
  const AgentRItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 8),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Wg.timeWg(timeData: data.timestamp!, size: 14)),
                Text(
                  '${NumF.decimals(num: data.comAgent!)}%',
                  style: TextStyle(color: data.comAgent! > 0 ? AppColors.primaryColor : Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(color: Colors.white24),
                    color: data.status == 'pending'
                        ? Colors.deepOrange
                        : data.status == 'cancel'
                            ? Colors.red
                            : Colors.green,
                  ),
                  child: Text(data.status!.toUpperCase(), style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                ),
              ],
            ),
            _fromTo()
          ],
        ),
      ),
    );
  }

  Widget _fromTo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(visible: data.timeConfirm != null, child: Wg.timeWg(timeData: data.timeConfirm ?? Timestamp.now(), size: 14)),
        Text('To: ${stringDot(text: data.uidF1!)}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}
