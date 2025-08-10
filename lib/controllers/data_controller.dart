import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:on_track/models/todo.dart';
import 'package:on_track/models/user.dart';
import 'package:on_track/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  List<Todo> todos = <Todo>[].obs;
  List<String> savedTodo = <String>[].obs;

  var loaded = false.obs;

  AppUser? user;

  NotificationService notificationService = NotificationService(
    FlutterLocalNotificationsPlugin(),
  );

  Future<void> serializeTODO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (savedTodo.isNotEmpty) {
      savedTodo.clear();
    }
    for (int i = 0; i < todos.length; i++) {
      String todo = json.encode(todos[i]);
      savedTodo.add(todo);
      await prefs.setStringList("com.chidi.TODO", savedTodo);
    }
  }

  void deserializeTODO() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fromMem = prefs.getStringList("com.chidi.TODO");
    if (fromMem != null) {
      print(fromMem);
      todos.clear();
      savedTodo = fromMem;
      for (int i = 0; i < savedTodo.length; i++) {
        Todo todo = Todo.fromJson(json.decode(savedTodo[i]));
        todos.add(todo);
      }
    }
    loaded(true);
  }

  Future<bool> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedUser = prefs.getString("com.chidi.TODO_USER");
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
    String saveUser = json.encode(newUser);
    await prefs.setString("com.chidi.TODO_USER", saveUser);
    return true;
  }

  Future<void> updateTaskItemToServer(Todo todo) async {
    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == todo.id) {
        todos[i] = todo;
        break;
      }
    }
    await serializeTODO();
  }

  Future<void> putTaskItemsToServer(Todo todo) async {
    todos.add(todo);
    await serializeTODO();
  }

  Future<void> deleteTaskItemToServer(Todo todo) async {
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
      // Use putIfAbsent to create a new list only if the key doesn't exist.
      // Then, add the current todo to that key's list.
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
