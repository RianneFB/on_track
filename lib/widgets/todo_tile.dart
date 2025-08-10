import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:on_track/controllers/data_controller.dart';
import 'package:on_track/models/todo.dart';
import 'package:on_track/widgets/create_todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final DataController dataController;

  const TodoTile({super.key, required this.todo, required this.dataController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      key: ValueKey(todo.id),
      child: Slidable(
        key: ValueKey(todo.id),
        startActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                _moveToNextDay();
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary,
              icon: Icons.keyboard_double_arrow_right,
              label: 'Do tomorrow',
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                dataController.deleteTaskItemToServer(todo);
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Material(
          type: MaterialType.card,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(12),
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onLongPress: () {
              showDialog(
                useSafeArea: false,
                context: context,
                builder: (BuildContext context) {
                  return CreateTodo(isEdit: true, todo: todo);
                },
              );
            },
            onTap: () => _updateDoneStatus(),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todo.isDone,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              visualDensity: VisualDensity.comfortable,
              onChanged: (_) => _updateDoneStatus(),
            ),
            trailing:
                todo.isReminder ? const Icon(Icons.notifications_active) : null,
          ),
        ),
      ),
    );
  }

  Future<void> _moveToNextDay() async {
    // When postponing a task, reset completion status so it becomes active
    // again on the new date.
    if (todo.isDone) {
      todo.isDone = false;
    }
    todo.todoDate = todo.todoDate.add(const Duration(days: 1));
    await dataController.updateTaskItemToServer(todo);
  }

  Future<void> _updateDoneStatus() async {
    todo.isDone = !todo.isDone;
    await dataController.updateTaskItemToServer(todo);
  }
}
