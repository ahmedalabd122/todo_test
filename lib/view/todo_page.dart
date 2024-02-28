import 'package:flutter/material.dart';
import 'package:test_gravition/data/request.dart';
import 'package:test_gravition/model/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.todo});

  final TodoModel todo;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Text(widget.todo.todo),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.todo.completed = !widget.todo.completed;
                Request().updateTodo(widget.todo);
                setState(() {});
              },
              child: Text(widget.todo.completed
                  ? 'Marck as not done'
                  : 'Marck as done'),
            ),
          ],
        ),
      ),
    );
  }
}
