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
        title: Text('New Task'),
        backgroundColor: Color.fromARGB(255, 34, 141, 235),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'What is to be done?'),
              ),
              SizedBox(height: 16),
              Row(
          children: [
            Expanded(
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: _selectedDueTime != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDueTime!)
                : 'Not set',
          ),
          decoration: InputDecoration(
            labelText: 'Due Time',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDueTime(context);
              },
            ),
          ),
        ),
            ),
          ],
        ),
        SizedBox(height: 16),
              
              
            ],
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 34, 141, 235),
                onPressed: () {
                  _addTask(context);
                },
                child: Icon(Icons.check)
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
          _selectedDueTime = DateTime(picked.year, picked.month, picked.day,
              selectedTime.hour, selectedTime.minute);
        });
      }
    }
  }

  void _addTask(BuildContext context) async {
    String taskName = _taskController.text;

    if (taskName.isNotEmpty && _selectedDueTime != null) {
      // Open the 'Tasks' box
      Box<Task> taskBox = await Hive.openBox<Task>('Tasks');

      Task newTask = Task(name: taskName, dueTime: _selectedDueTime!);

      taskBox.add(newTask);

      Navigator.pop(context, newTask);
    } else {
      // Handle empty task name
      _showErrorDialog(
          context, 'Task name cannot be empty, and due time must be set.');
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
