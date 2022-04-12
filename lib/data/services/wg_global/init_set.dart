import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../utils.dart';
import '../services.dart';

class SetInitPage extends StatelessWidget {
  const SetInitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(title: const Text('SET Project Init')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(paddingDefault),
              child: Column(
                children: [
                  ElevatedButton(
                    child: const Text('Add Settings', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      addSetting();
                    },
                  ),
                  const SizedBox(height: paddingDefault),
                  ElevatedButton(
                    child: const Text('Add Pack', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      addNewPack();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> addSetting() async {
  SetModel setData = SetModel(
    maxAgent: 35,
    minInvest: 100,
    minTransfer: 10,
    minWithdraw: 10,
    feeTrans: 0,
    feeWithdraw: 0.05,
    priceToken: 0.001,
    priceTokenOld: 0,
    vNew: '1.0.0+1',
  );
  await updateAnyField(coll: 'settings', docId: 'set', data: setData.toJson());
}

Future<void> addNewPack() async {
  PackagesModel packData = PackagesModel(
    number: 1,
    minInvest: 10,
    maxInvest: 1000,
    cycle: 180,
    rateD: '1',
    run: true,
    textNoRun: '',
    timeRun: now,
    title: 'title',
  );
  await addDocToCollDynamic(coll: 'packs', data: packData.toJson());
}
