import 'package:test_gravition/data/request.dart';
import 'package:test_gravition/model/todo_model.dart';

class TodosModel {
  final List<TodoModel> todos;
  final int total;
  final int skip;
  final int limit;

  TodosModel({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodosModel.fromJson(Map<String, dynamic> jsonData) {
    return TodosModel(
      todos: jsonData['todos']
          .map<TodoModel>((json) => TodoModel.fromJson(json))
          .toList(),
      total: jsonData['total'],
      skip: jsonData['skip'],
      limit: jsonData['limit'],
    );
  }
}
