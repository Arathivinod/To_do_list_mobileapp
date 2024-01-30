// edit_task_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/database.dart';

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _taskController;
  final TextEditingController _dueTimeController;
  final Task task;

  EditTaskScreen({required this.task})
      : _taskController = TextEditingController(text: task.name),
        _dueTimeController = TextEditingController(
          text:
              "${task.dueTime.year}-${task.dueTime.month}-${task.dueTime.day} ${task.dueTime.hour}:${task.dueTime.minute}",
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            TextField(
              controller: _dueTimeController,
              decoration:
                  InputDecoration(labelText: 'Due Time (YYYY-MM-DD HH:mm)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _editTask(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _editTask(BuildContext context) {
    String taskName = _taskController.text;
    String dueTimeString = _dueTimeController.text;

    if (taskName.isNotEmpty && dueTimeString.isNotEmpty) {
      try {
        DateTime dueTime = DateTime.parse(dueTimeString);
        Task editedTask =
            Task.withKey(key: task.key, name: taskName, dueTime: dueTime);

        Box<Task> taskBox = Hive.box<Task>('tasks');
        taskBox.put(editedTask.key, editedTask);

        Navigator.pop(context, editedTask);
      } catch (e) {
        // Handle invalid date format
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid date format. Please enter a valid date.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
