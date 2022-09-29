import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

initLocator() {
  locator.registerSingleton<TaskService>(TaskService());
}

class Task {
  String title = '';
  String description = '';
  String image = '';
}

class TaskService {
  List<Task> tasklist = [];
}

void main() {
  initLocator();
  runApp(MaterialApp(
    title: 'Flutter Navigation',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  TaskService tsk = locator.get<TaskService>();
  List<Task> list = [];

  @override
  void initState() {
    list = tsk.tasklist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            list[index].title,
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Text(list[index].description),
                          leading: Image.network(
                            list[index].image,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Center(
            child: FloatingActionButton(
              child: Text('press'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
                setState(() {
                  list = tsk.tasklist;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  Task task = Task();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => task.title = value,
            decoration: InputDecoration(
                labelText: 'Enter Name', hintText: 'Enter Your Name'),
          ),
          TextField(
            onChanged: (value) => task.description = value,
            decoration: InputDecoration(
                labelText: 'Description', hintText: 'description'),
          ),
          TextField(
            onChanged: (value) => task.image = value,
            decoration:
                InputDecoration(labelText: 'Image Url', hintText: 'URL'),
          ),
          FloatingActionButton(
            onPressed: () {
              locator.get<TaskService>().tasklist.add(task);
              print(locator.get<TaskService>().tasklist);
              Navigator.pop(context);
            },
            child: Text('Sumbit'),
          ),
        ],
      ),
    );
  }
}
