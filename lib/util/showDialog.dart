import 'package:flutter/material.dart';

Future<void> showMyDialog(
    String id, Function deleteTask, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.red),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure do you want delete this Task?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              deleteTask(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
