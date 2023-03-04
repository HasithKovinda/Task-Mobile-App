import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_tasks_app/provider/task_provider.dart';
import 'package:to_do_tasks_app/widgets/task_contianer.dart';
import '../Model/Tasks.dart';
import '../util/showDialog.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;
  static const routeName = '/auth';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = false;

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<retrieve>(context).fetchTasks().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //take text input value
  final taskName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<retrieve>(context);
//get user input
    Future<void> getUserInput() async {
      setState(() {
        isLoading = true;
      });
      await task.addTasks(Tasks(id: '', name: taskName.text, status: false));
      taskName.clear();
      setState(() {
        isLoading = false;
      });
    }

    void changeStatus(String id, bool? value) {
      task.changeTaskStatus(id, value);
    }

// delete task
    void deleteTask(String id) {
      task.deleteTask(id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'Add Todo'),
                          controller: taskName,
                        ),
                      ),
                      IconButton(
                        onPressed: getUserInput,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                TaskContainer(
                    changeStatus: changeStatus, deleteTask: deleteTask)
              ],
            ),
    );
  }
}
