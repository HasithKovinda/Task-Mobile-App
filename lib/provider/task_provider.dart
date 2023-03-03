import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../Model/Tasks.dart';

import 'package:http/http.dart' as http;

class Task with ChangeNotifier {
  List<Tasks> _tasks = [];
  List<Tasks> get getAllTasks {
    return [..._tasks];
  }

  final String? authToken;

  Task(this.authToken, this._tasks);

  Future<void> addTasks(Tasks task) async {
    try {
      var url = Uri.https('ctse-14e8f-default-rtdb.firebaseio.com',
          '/tasks.json', {'auth': authToken});
      var response = await http.post(url,
          body: json.encode({'name': task.name, 'status': task.status}));
      Tasks newTask = Tasks(
          name: task.name,
          status: task.status,
          id: json.decode(response.body)['name']);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchTasks() async {
    try {
      var url = Uri.https('ctse-14e8f-default-rtdb.firebaseio.com',
          '/tasks.json', {'auth': authToken});
      var response = await http.get(url);
      if (json.decode(response.body) == null) {
        _tasks = [];
      } else {
        final data = json.decode(response.body) as Map<String, dynamic>;
        List<Tasks> loadTaskList = [];
        data.forEach((id, task) {
          loadTaskList
              .add(Tasks(id: id, name: task['name'], status: task['status']));
        });
        _tasks = loadTaskList;
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeTaskStatus(String id, bool? value) async {
    final taskIndex = _tasks.indexWhere((el) => el.id == id);
    _tasks[taskIndex].status = value!;
    notifyListeners();
    var url =
        Uri.https('ctse-14e8f-default-rtdb.firebaseio.com', '/tasks/$id.json');
    await http.patch(url, body: json.encode({'status': value}));
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
    var url =
        Uri.https('ctse-14e8f-default-rtdb.firebaseio.com', '/tasks/$id.json');
    await http.delete(url);
  }
}
