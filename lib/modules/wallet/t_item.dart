import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../../data/utils.dart';

// ignore: must_be_immutable
class TransactionsItem extends StatelessWidget {
  TransactionsModel data;
  TransactionsItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Wg.timeWg(timeData: Timestamp.fromMillisecondsSinceEpoch(data.timeMilis!), size: 14)),
                  _amount(),
                  const SizedBox(width: 5),
                  Visibility(
                    visible: data.type == 'Withdraw',
                    child: Container(
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
                      child: Text(data.status!.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _type(),
                  _fromTo(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        data.amount! > 0 ? const Icon(Icons.add, size: 15) : const Text(''),
        Text(
          NumF.decimals(num: data.amount ?? 0),
          style: TextStyle(color: data.amount! > 0 ? AppColors.primaryColor : Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Visibility(
          visible: data.type == 'Withdraw' && data.fee! > 0,
          child: Text(
            '(${NumF.decimals(num: (data.amount! * -1) - ((data.amount! * -1) * data.fee!))})',
            style: TextStyle(color: AppColors.primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 5),
        // Text(data.symbol!, style: TextStyle(color: AppColors.primaryColor, fontSize: 15, fontWeight: FontWeight.bold)),
        Image.asset(getLogoByWallet(data.symbol!), height: 30),
      ],
    );
  }

  Widget _type() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: data.type == 'Withdraw' && data.fee! > 0,
          child: Row(
            children: [
              Text(data.type!, style: TextStyle(color: AppColors.primaryColor, fontSize: 11)),
              const SizedBox(width: 5),
              Text(data.symbol!, style: TextStyle(color: AppColors.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 3),
              Visibility(
                visible: data.type == 'Withdraw' && data.fee! > 0,
                child: Text(
                  "${data.fee! * 100}%",
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Visibility(visible: data.note!.isNotEmpty, child: Text(data.note!, style: TextStyle(color: AppColors.primaryColor, fontSize: 11), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _fromTo() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text((data.amount! < 0 ? "To: " : "From: "), style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
                data.uOtherName! == ''
                    ? 'Me'
                    : data.type == 'Withdraw'
                        ? stringDot(text: data.uOtherName!)
                        : stringDot(text: data.uOtherName!),
                style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
