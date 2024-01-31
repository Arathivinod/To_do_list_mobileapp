// add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/database.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDueTime = DateTime.now();

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
            SizedBox(height:8),
            Row(children: [
              Text('Due Time: ${_selectedDueTime !=null ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDueTime!) : 'Not set'}'),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _selectDueTime(context);
                  },
                  child: Text('Select Due Time'),
                ),
              ],
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
  Future<void> _selectDueTime(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueTime ?? DateTime.now()),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDueTime = DateTime(picked.year, picked.month, picked.day, selectedTime.hour, selectedTime.minute);
        });
      }
    }
  }

 void _addTask(BuildContext context) async {
    String taskName = _taskController.text;

    if (taskName.isNotEmpty  && _selectedDueTime != null) {
      // Open the 'Tasks' box
      Box<Task> taskBox = await Hive.openBox<Task>('Tasks');

      Task newTask = Task(name: taskName, dueTime: _selectedDueTime!);

      taskBox.add(newTask);

      Navigator.pop(context, newTask);
    } else {
      // Handle empty task name
      _showErrorDialog(context, 'Task name cannot be empty, and due time must be set.');
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
