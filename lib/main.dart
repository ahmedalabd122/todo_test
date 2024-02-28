import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_gravition/data/request.dart';
import 'package:test_gravition/model/todos_model.dart';
import 'package:test_gravition/view/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  int skip = 0;
  int limit = 5;

  late TodosModel _todos;
  late Request _request;

  bool loading = false;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(detectScrolling);

    _request = Request();
    loading = true;
    fetchData();
    loading = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Future fetchData() async {
    if (skip == 0) {
      var response = await _request.getToDos(limit, skip);
      skip = limit;

      _todos = TodosModel.fromJson(response);
      counter = _todos.todos.length;
    } else if (_todos.total >= (counter + limit)) {
      var response = await _request.getToDos(limit, skip);
      var temp = TodosModel.fromJson(response);
      _todos.todos.addAll(temp.todos);
      skip += limit;
      counter = _todos.todos.length;
    } else {}
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: counter != 0
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: _todos.todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(
                          alignment: Alignment.center,
                          color: Colors.red,
                          child: const Text(
                            'Deleted',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onDismissed: (direction) {
                          _todos.todos.removeAt(index);
                          counter--;
                          setState(() {});
                        },
                        key: UniqueKey(),
                        child: GestureDetector(
                          onTap: () {
                            log(_todos.todos[index].id.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TodoPage(todo: _todos.todos[index]),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _todos.todos[index].completed,
                                      onChanged: (value) {
                                        _todos.todos[index].completed = value!;
                                        setState(() {});
                                      }),
                                  Expanded(
                                    child: Text(
                                      _todos.todos[index].todo,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: loading
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: const CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            fetchData();
                          },
                          child: const Text('Load more'),
                        ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void detectScrolling() {
    if (controller.position.atEdge) {
      bool isTop = controller.position.pixels == 0;
      if (!isTop) {
        setState(() {
          loading = true;
        });
        fetchData();
      }
    }
  }
}
