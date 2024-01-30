// add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/database.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
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
                _addTask(context);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

 void _addTask(BuildContext context) async {
  String taskName = _taskController.text;
  String dueTimeString = _dueTimeController.text;

  if (taskName.isNotEmpty && dueTimeString.isNotEmpty) {
    DateTime? dueTime = _parseDueTime(dueTimeString);

    if (dueTime != null) {
      // Open the 'Tasks' box
      Box<Task> taskBox = await Hive.openBox<Task>('Tasks');

      Task newTask = Task(name: taskName, dueTime: dueTime);

      taskBox.add(newTask);

      Navigator.pop(context, newTask);
    } else {
      // Handle invalid date format
      _showErrorDialog(context,
          'Invalid date format. Please enter a valid date and time.');
    }
  }
}


  DateTime _parseDueTime(String dueTimeString) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parseStrict(dueTimeString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime(
          1900); // Return a default date or use another sentinel value
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 8),
            Text(
                'Please enter the date and time in the format: YYYY-MM-DD HH:mm'),
          ],
        ),
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
