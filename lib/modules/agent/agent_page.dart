import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'agent_ctr.dart';
import 'agent_item.dart';
import 'agr_item.dart';

class AgentPage extends GetView<UserCtr> {
  const AgentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userDB!.phone != null) {
        return Scaffold(
          backgroundColor: AppColors.primaryDeep,
          appBar: AppBar(title: Text(myAg)),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(image: AppColors.bgBlack),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        refLinkWg(reLink: UserCtr.to.reLink),
                        const SizedBox(height: 10),
                        Wg.textRowWg(title: '$myAgPt:', text: '${controller.userDB!.comAgent!}%', style: const TextStyle(color: Colors.white, fontSize: 18))
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.people_alt, color: Colors.white),
                          onPressed: () => AgentCtrST.to.by.value = '',
                          label: Text(myAg),
                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primaryLight),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.elevator, color: Colors.white),
                          onPressed: () => AgentCtrST.to.by.value = 'agR',
                          label: Text(setAg),
                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), primary: AppColors.primaryLight),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetX<AgentCtrST>(
                      init: Get.put(AgentCtrST()),
                      builder: (ctr) {
                        if (ctr.agentF1List.isNotEmpty) {
                          ctr.agentF1ListSort();
                          return AgentCtrST.to.by.value == ''
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ctr.agentF1List.length,
                                  itemBuilder: (_, index) {
                                    return AgentItem(userData: ctr.agentF1List[index]);
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ctr.agentR.length,
                                  itemBuilder: (_, index) {
                                    return AgentRItem(data: ctr.agentR[index]);
                                  },
                                );
                        } else {
                          return Wg.noData();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
