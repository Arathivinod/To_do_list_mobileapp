// edit_task_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/database.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  late TextEditingController _dueTimeController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.name);
    _dueTimeController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(widget.task.dueTime),
    );
  }

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
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            TextFormField(
              controller: _dueTimeController,
              decoration: InputDecoration(labelText: 'Due Time (YYYY-MM-DD HH:mm)'),
              onTap: () async {
                DateTime? pickedDate = await _pickDate(context, widget.task.dueTime);
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await _pickTime(context, widget.task.dueTime);
                  if (pickedTime != null) {
                    DateTime pickedDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    _dueTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(pickedDateTime);
                  }
                }
              },
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

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime initialDate) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    return pickedTime;
  }

  void _editTask(BuildContext context) async {
    String taskName = _taskController.text;
    String dueTimeString = _dueTimeController.text;

    if (taskName.isNotEmpty && dueTimeString.isNotEmpty) {
      try {
        DateTime dueTime = DateFormat('yyyy-MM-dd HH:mm').parseStrict(dueTimeString);
        Task editedTask = Task.withKey(key: widget.task.key, name: taskName, dueTime: dueTime);

        Box<Task> taskBox = await Hive.openBox<Task>('Tasks');
        taskBox.put(editedTask.key, editedTask);

        Navigator.pop(context, editedTask);
      } catch (e) {
        // Handle invalid date format
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid date format. Please enter a valid date and time.'),
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