import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import 'todo_ctrst.dart';
import 'todo_item.dart';

TodoCtrST todeCTr = Get.find();

class TodoPage extends GetWidget<UserCtr> {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(
        title: const Text("All Todos"),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  tooltip: 'Todo add',
                  onPressed: () {
                    if (controller.userDB!.role == 'dev') {
                      Get.defaultDialog(
                        title: 'Add Todo Here:',
                        content: todeCTr.todoFormAdd(),
                      );
                    } else {
                      Get.defaultDialog(
                        middleText: 'Not accepted!',
                        textConfirm: "OK",
                        confirmTextColor: Colors.white,
                        onConfirm: () => Get.back(),
                      );
                    }
                  }),
              // InkWell(
              //     child: Icon(Icons.add_circle, size: 40),
              //     onTap: () {

              //     }),
              const SizedBox(width: 8)
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          // SizedBox(height: 10),
          // Image.asset('assets/brand/192.png', height: 100),
          // SizedBox(height: 20),
          GetX<TodoCtrST>(
            init: TodoCtrST(),
            builder: (todoCtr) {
              if (todoCtr.todoList != []) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: todoCtr.todoList.length,
                    itemBuilder: (_, index) {
                      return TodoItem(
                        data: todoCtr.todoList[index],
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Wg.noData());
              }
            },
          )
        ],
      ),
    );
  }
}
