import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../data/user_ctr.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TodoCtrST extends GetxController {
  final Rx<List<TodoModel>> _todoList = Rx<List<TodoModel>>([]);
  List<TodoModel> get todoList => _todoList.value;

  @override
  void onInit() {
    _todoList.bindStream(getStreamTodo()); //stream coming from firebase
    super.onInit();
  }

  @override
  void dispose() {
    _todoList.close();
    _todoList.value = [];
    super.dispose();
  }

  Stream<List<TodoModel>> getStreamTodo() {
    return _firestore
        .collection("todos")
        .where('teamWork', arrayContainsAny: [(UserCtr.to.userDB!.uid)])
        .orderBy("priority", descending: true)
        .orderBy("timeCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> query) {
          List<TodoModel> retVal = [];
          for (var element in query.docs) {
            retVal.add(TodoModel.fromDocumentSnapshot(element));
          }
          return retVal;
        });
  }

  // --------TODO Modules:
  Future<void> addTodo(TodoModel todo) async {
    try {
      await _firestore.collection("todos").add(todo.toJson());
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  Future<void> updateTodo(String? todoId, data) async {
    try {
      _firestore.collection("todos").doc(todoId).set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }

  Widget todoFormAdd() {
    final TextEditingController _titleTodoController = TextEditingController();
    final TextEditingController _contentTodoController = TextEditingController();
    final TextEditingController _processController = TextEditingController();
    final TextEditingController _priorityController = TextEditingController();
    final TextEditingController _timeLeftController = TextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleTodoController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              // width: 400,
              child: TextFormField(
                maxLines: 10000,
                controller: _contentTodoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                style: const TextStyle(fontFamily: "courier"),
              ),
            ),
            TextFormField(
              controller: _processController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tiến độ (nhập số)'),
            ),
            TextFormField(
              controller: _priorityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sự ưu tiên'),
            ),
            TextFormField(
              controller: _timeLeftController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Time Left'),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.add_circle),
              iconSize: 60,
              color: Colors.green,
              onPressed: () async {
                if (_titleTodoController.text != "" && _contentTodoController.text != "") {
                  TodoModel todo = TodoModel(
                    creator: UserCtr.to.userDB!.uid,
                    title: _titleTodoController.text,
                    content: _contentTodoController.text,
                    priority: int.parse(_priorityController.text),
                    process: double.parse(_processController.text),
                    teamWork: [UserCtr.to.userDB!.uid],
                    roles: {'${UserCtr.to.userDB!.uid}': 'w'},
                    timeCreated: Timestamp.now(),
                    timeLeft: int.parse(_timeLeftController.text),
                  );
                  Get.back();
                  await addTodo(todo);
                  _titleTodoController.clear();
                  _contentTodoController.clear();
                  _priorityController.clear();
                  _processController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget todoFormUpdate(TodoModel todoData) {
    final TextEditingController _titleTodoController = TextEditingController();
    final TextEditingController _contentTodoController = TextEditingController();
    final TextEditingController _processController = TextEditingController();
    final TextEditingController _priorityController = TextEditingController();
    final TextEditingController _timeLeftController = TextEditingController();
    _titleTodoController.text = todoData.title!;
    _contentTodoController.text = todoData.content!;
    _processController.text = todoData.process!.toString();
    _priorityController.text = todoData.priority!.toString();
    _timeLeftController.text = todoData.timeLeft!.toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleTodoController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              // width: 400,
              child: TextFormField(
                maxLines: 10000,
                controller: _contentTodoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                style: const TextStyle(fontFamily: "courier"),
              ),
            ),
            TextFormField(
              controller: _processController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tiến độ (nhập số)'),
            ),
            TextFormField(
              controller: _priorityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sự ưu tiên'),
            ),
            TextFormField(
              controller: _timeLeftController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Time Left'),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.add_circle),
              iconSize: 60,
              color: Colors.green,
              onPressed: () async {
                if (_titleTodoController.text != "" && _contentTodoController.text != "") {
                  Get.back();
                  await updateTodo(todoData.id, {
                    'title': _titleTodoController.text,
                    'content': _contentTodoController.text,
                    'priority': int.parse(_priorityController.text),
                    'process': double.parse(_processController.text),
                    'timeLeft': int.parse(_timeLeftController.text),
                  });
                  _titleTodoController.clear();
                  _contentTodoController.clear();
                  _priorityController.clear();
                  _processController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleTodo(String? todoId) async {
    try {
      _firestore.collection("todos").doc(todoId).delete();
    } catch (e) {
      debugPrint('$e');
      rethrow;
    }
  }
}
