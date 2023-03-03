import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_tasks_app/provider/auth_provider.dart';
import 'package:to_do_tasks_app/provider/task_provider.dart';
import './screen/auth_screen.dart';
import './widgets/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Task>(
            create: (ctx) => Task('', []),
            update: (_, auth, previous) => Task(auth.token as String,
                previous == null ? [] : previous.getAllTasks),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? MyHomePage(title: 'Flutter Demo Home Page')
                : AuthRoute(),
          ),
        ));
  }
}
