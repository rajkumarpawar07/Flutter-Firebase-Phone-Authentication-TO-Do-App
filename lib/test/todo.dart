import 'package:hive/hive.dart';

// part 'todo.g.dart'; // Hive generator will generate a file for type adapters

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime date;

  Todo({required this.title, required this.date});
}
