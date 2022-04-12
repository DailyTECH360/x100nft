import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../data/models/models.dart';
import '../../data/utils.dart';
import 'todo_ctrst.dart';

class TodoItem extends GetView<TodoCtrST> {
  final TodoModel? data;
  const TodoItem({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int timeStartMilis = (data!.timeStart ?? data!.timeCreated!).millisecondsSinceEpoch;
    int endTimeMilis = (timeStartMilis + (data!.timeLeft! * 86400000));
    int timePass = ((Timestamp.now().millisecondsSinceEpoch - timeStartMilis) / 86400000).round();
    double percent = (timePass / data!.timeLeft!) > 1 ? 1 : (timePass / data!.timeLeft!);
    debugPrint('timePass: $timePass');
    debugPrint('Percent: $percent');
    return Card(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10), //EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: data!.priority! > 50
          ? Colors.orange[100]
          : data!.process == 100
              ? Colors.green[100]
              : null,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data!.title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.orange.withOpacity(0.7),
                  child: Text('${data!.priority}', style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const Divider(height: 8, thickness: 1, color: Colors.black12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // if (data!.roles! == 'w') {
                      Get.defaultDialog(
                          middleText: 'Delete!\n"${data!.title}"\nAre you sure?',
                          textCancel: 'No',
                          textConfirm: 'YES',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            controller.deleTodo(data!.id).whenComplete(() => Get.back());
                          });
                      // } else {
                      //   Get.defaultDialog(
                      //     middleText: 'Not accepted!',
                      //     textConfirm: "OK",
                      //     confirmTextColor: Colors.white,
                      //     onConfirm: () => Get.back(),
                      //   );
                      // }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${data!.content}', style: const TextStyle(fontSize: 14)),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wg.timeWg(timeData: data!.timeCreated!, size: 14),
                            Wg.timeWg(timeData: Timestamp.fromMillisecondsSinceEpoch(endTimeMilis), size: 14),
                          ],
                        ),
                        Visibility(
                          visible: endTimeMilis > Timestamp.now().millisecondsSinceEpoch && data!.timeLeft! > 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(height: 5),
                              Wg.countdownTimerNew(endTime: endTimeMilis),
                              const SizedBox(width: 5),
                              LinearPercentIndicator(
                                animation: true,
                                percent: percent,
                                leading: const Text('0'),
                                trailing: Text('${data!.timeLeft}'),
                                alignment: MainAxisAlignment.center,
                                widgetIndicator: CircleAvatar(
                                    radius: 16, backgroundColor: Colors.red, child: Text('$timePass', style: const TextStyle(color: Colors.white))),
                              ),
                              const Divider(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("ckick edit");
                    // if (data!.roles!['$uid'] == 'w') {
                    Get.defaultDialog(
                      title: 'Edit Todo:',
                      content: controller.todoFormUpdate(data!),
                    );
                    // } else {
                    //   Get.defaultDialog(
                    //     middleText: 'Not accepted!',
                    //     textConfirm: "OK",
                    //     confirmTextColor: Colors.white,
                    //     onConfirm: () => Get.back(),
                    //   );
                    // }
                  },
                  child: CircularPercentIndicator(
                    radius: Get.width > 450 ? 100 : 75,
                    lineWidth: 8.0,
                    animation: true,
                    percent: data!.process! / 100,
                    center: Text(
                      '${data!.process}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    // footer: new Text("Tiến độ", style: new TextStyle(fontSize: 16.0)),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
