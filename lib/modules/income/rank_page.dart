import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

class RankPage extends GetView<UserCtr> {
  final List<RankModel> levelList = <RankModel>[
    RankModel(rank: 1, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 2500),
    RankModel(rank: 2, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 5000),
    RankModel(rank: 3, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 25000),
    RankModel(rank: 4, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 50000),
    RankModel(rank: 5, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 100000),
    RankModel(rank: 6, dkActive: true, dkTotalF1BronzeL: 1, dkTotalF1BronzeR: 1, investPack: 2, dkNhanhYeu: 250000),
  ];

  RankPage({Key? key}) : super(key: key);

  String getPackName(int investPack) {
    if (investPack == 1) {
      return 'Bronze 250$symbolAll';
    } else if (investPack == 2) {
      return 'Silver 1000$symbolAll';
    } else if (investPack == 3) {
      return 'Gold 2500$symbolAll';
    } else if (investPack == 4) {
      return 'Diamond 5000$symbolAll';
    } else if (investPack == 5) {
      return 'Blue Diamond 10.000$symbolAll';
    } else {
      return 'Lock';
    }
  }

  @override
  Widget build(BuildContext context) {
    double volumeNhanhYeu = 0;
    controller.userDB!.volumeL! <= controller.userDB!.volumeR! ? volumeNhanhYeu = controller.userDB!.volumeL! : volumeNhanhYeu = controller.userDB!.volumeR!;
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(title: const Text('My Level')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Wg.rank(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: levelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: Colors.white12,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  backgroundColor: controller.userDB!.rank == levelList[index].rank ? Colors.green : Colors.white24,
                                  child: Text('${levelList[index].rank}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Level condition ${levelList[index].rank}:', style: TextStyle(color: AppColors.primarySwatch, fontWeight: FontWeight.bold, fontSize: 18)),
                                  Row(
                                    children: [
                                      controller.userDB!.rankPack! >= controller.set!.startPackAmount!
                                          ? const Icon(Icons.check_circle, color: Colors.green)
                                          : const Icon(Icons.close, color: Colors.grey),
                                      Text(' - Start pack ${controller.set!.startPackAmount!}$symbolUsdt',
                                          style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      controller.userDB!.investPack! >= levelList[index].investPack!
                                          ? const Icon(Icons.check_circle, color: Colors.green)
                                          : const Icon(Icons.close, color: Colors.grey),
                                      Text(' - My investPack >= ${getPackName(levelList[index].investPack!)}',
                                          style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      volumeNhanhYeu >= levelList[index].dkNhanhYeu!
                                          ? const Icon(Icons.check_circle, color: Colors.green)
                                          : const Icon(Icons.close, color: Colors.grey),
                                      Text(' - Volume small team >= ${NumF.decimals(num: levelList[index].dkNhanhYeu!.toDouble())}',
                                          style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
