import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'models/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Task> _myBox; // Use _myBox instead of taskBox

  @override
  void initState() {
    super.initState();
    _openTaskBox();
  }

  Future<void> _openTaskBox() async {
    _myBox = await Hive.openBox<Task>('mybox'); // Open 'mybox' instead of 'tasks'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: FutureBuilder(
        future: _openTaskBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: _myBox.length,
              itemBuilder: (context, index) {
                Task task = _myBox.getAt(index)!;
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text("Due: ${_formatDueTime(task.dueTime)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTask(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _myBox.deleteAt(index);
                          setState(() {}); // Trigger a rebuild after deleting
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTaskScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _navigateToAddTaskScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (result != null && result is Task) {
      _myBox.add(result);
      setState(() {}); // Trigger a rebuild after adding
    }
  }

  _editTask(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditTaskScreen(task: _myBox.getAt(index)!)),
    );

    if (result != null && result is Task) {
      _myBox.putAt(index, result);
      setState(() {}); // Trigger a rebuild after editing
    }
  }

  String _formatDueTime(DateTime dueTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dueTime);
  }
}
