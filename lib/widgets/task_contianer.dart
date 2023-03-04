import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/tasks.dart';
import '../util/getColor.dart';
import '../provider/task_provider.dart';
import '../util/showDialog.dart';

class TaskContainer extends StatelessWidget {
  final Function changeStatus;
  final Function deleteTask;

  const TaskContainer(
      {super.key, required this.changeStatus, required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<retrieve>(context);
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: ListView.builder(
            itemCount: task.getAllTasks.length,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: task.getAllTasks[index].status,
                          onChanged: (bool? value) {
                            changeStatus(task.getAllTasks[index].id, value);
                          },
                        ),
                        task.getAllTasks[index].status
                            ? Text(
                                task.getAllTasks[index].name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              )
                            : Text(
                                task.getAllTasks[index].name,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showMyDialog(
                            task.getAllTasks[index].id, deleteTask, context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
