import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  int key = 0;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime dueTime;

  Task({required this.name, required this.dueTime});

  // Add this constructor to create a Task with a key
  Task.withKey({required this.key, required this.name, required this.dueTime});
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task.withKey(
      key: reader.readInt(),
      name: reader.readString(),
      dueTime: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeInt(obj.key);
    writer.writeString(obj.name);
    writer.writeString(obj.dueTime.toIso8601String());
  }
}
