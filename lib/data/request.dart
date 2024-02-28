import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:test_gravition/model/todo_model.dart';
import 'package:test_gravition/model/todos_model.dart';

class Request {
  Dio dio = Dio();
  String baseUrl = 'https://dummyjson.com/todos';

  Future getToDos(int limit, int skip) async {
    try {
      Response response = await dio.get('$baseUrl?limit=$limit&skip=$skip');

      //TodosModel todosModel = TodosModel.fromJson(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future getTodo(int id) async {
    Response response = await dio.get('$baseUrl/$id');
    print(response.toString());
    return response;
  }

  updateTodo(TodoModel todo) async {
    Response response = await dio.post(
      '$baseUrl/${todo.id}',
      data: todo.toJson(),
    );
  }

  addTodo(String todo) async {
    try {
      Response response = await dio.post('$baseUrl/add', data: {"todo": todo});
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
