import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' hide Response;
import 'package:on_track/models/todo.dart';
import 'package:on_track/models/user.dart';
import 'package:on_track/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  RxList<Todo> todos = <Todo>[].obs;
  RxList<String> savedTodo = <String>[].obs;

  var loaded = false.obs;

  AppUser? user;

  NotificationService notificationService = NotificationService(
    FlutterLocalNotificationsPlugin(),
  );


  Future<void> fetchTodosFromServer() async {
    final dio = Dio();
    dio.options.baseUrl = "https://alphavantage.co";

    Response response;

    response = await dio.get("/todos");

    print(response.data.toString());

    List data = response.data;

    todos.clear();

    for (int i = 0; i < data.length; i++) {
      Todo todo = Todo.fromJson(data[i]);
      todos.add(todo);
    }

    await serializeTODO();
  }

  Future<void> serializeTODO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (savedTodo.isNotEmpty) {
      savedTodo.clear();
    }

    for (int i = 0; i < todos.length; i++) {
      String todo = json.encode(todos[i].toJson());
      savedTodo.add(todo);
    }

    await prefs.setStringList("com.rianne.ontrack.todos", savedTodo);
  }

  void deserializeTODO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var fromMem = prefs.getStringList("com.rianne.ontrack.todos");

    if (fromMem != null) {
      print(fromMem);

      todos.clear();
      savedTodo.assignAll(fromMem);

      for (int i = 0; i < savedTodo.length; i++) {
        Todo todo = Todo.fromJson(json.decode(savedTodo[i]));
        todos.add(todo);
      }
    }

    loaded(true);
  }

  Future<bool> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var savedUser = prefs.getString("com.rianne.ontrack.user");

    if (savedUser != null) {
      user = AppUser.fromJson(json.decode(savedUser));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveUser(String name, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    AppUser newUser = AppUser(
      name: name,
      email: email,
      creationDate: DateTime.now(),
      id: password,
    );

    String saveUser = json.encode(newUser.toJson());

    await prefs.setString("com.rianne.ontrack.user", saveUser);

    return true;
  }

  Future<void> putTaskItemsToServer(Todo todo) async {
    final dio = Dio();
    dio.options.baseUrl = "https://alphavantage.co";

    Response response;

    response = await dio.post(
      "/todos",
      data: todo.toJson(),
    );

    print(response.data.toString());

    todos.add(todo);

    await serializeTODO();
  }

  Future<void> updateTaskItemToServer(Todo todo) async {
    final dio = Dio();
    dio.options.baseUrl = "https://alphavantage.co";

    Response response;

    response = await dio.put(
      "/todos/${todo.id}",
      data: todo.toJson(),
    );

    print(response.data.toString());

    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == todo.id) {
        todos[i] = todo;
        break;
      }
    }

    await serializeTODO();
  }

  Future<void> deleteTaskItemToServer(Todo todo) async {
    final dio = Dio();
    dio.options.baseUrl = "https://alphavantage.co";

    Response response;

    response = await dio.delete("/todos/${todo.id}");

    print(response.data.toString());

    todos.removeWhere((t) => t.id == todo.id);

    await serializeTODO();
  }

  Map<DateTime, List<Todo>> groupTodosManually() {
    todos.sort((a, b) {
      if (!a.isDone && b.isDone) {
        return 1;
      } else if (a.isDone && !b.isDone) {
        return -1;
      }

      return a.createdAt.compareTo(b.createdAt);
    });

    final Map<DateTime, List<Todo>> map = {};

    for (final todo in todos) {
      var date = DateTime(
        todo.todoDate.year,
        todo.todoDate.month,
        todo.todoDate.day,
      );

      map.putIfAbsent(date, () => []).add(todo);
    }

    return map;
  }
}
