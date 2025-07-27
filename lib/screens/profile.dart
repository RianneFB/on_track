import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final DataController dataController;
  const ProfileScreen({super.key, required this.dataController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.dataController.user!.name[0],
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.dataController.user!.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Joined ${DateFormat("MMM yyyy").format(widget.dataController.user!.creationDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Completed Todos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    getCompletedTodo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TodoActivityGrid(dataController: widget.dataController),
          ],
        ),
      ),
    );
  }

  Widget getCompletedTodo() {
    var todosMap = widget.dataController.groupTodosManually();
    final completedCount =
        todosMap.values
            .expand((list) => list)
            .where((todo) => todo.isDone)
            .length;
    return Text(
      completedCount.toString(),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
