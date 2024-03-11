import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:flyin/test/todo.dart';
import 'package:flyin/test/todo.g.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'firebase_options.dart';
import 'authentication/authentication_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
          options: DefaultFirebaseOptions
              .currentPlatform) //currentPlatform - android , ios, web, etc
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  await FirebaseAppCheck.instance.activate();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todoList');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie app',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const CircularProgressIndicator(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  Box<Todo>? todoBox;
  int? selectedTaskIndex;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<Todo>('todoList');
  }

  void _showEditTaskModal(Todo task, int index) {
    // Show the modal to edit the task...
    _editTask(task.title, task.date, index);
  }

  void _editTask(String title, DateTime date, int index) {
    final Todo updatedTodo = Todo(title: title, date: date);
    todoBox!.putAt(index, updatedTodo);
  }

  void _deleteTask(int index) {
    todoBox!.deleteAt(index);
    setState(() {
      selectedTaskIndex = null; // Clear selection
    });
  }

  void _selectTask(int index) {
    setState(() {
      selectedTaskIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Tasks',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: <Widget>[
          if (selectedTaskIndex != null) ...[
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _deleteTask(selectedTaskIndex!);
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.edit),
            //   onPressed: () {
            //     _showEditTaskModal(
            //         todoBox!.getAt(selectedTaskIndex!)!, selectedTaskIndex!);
            //   },
            // ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selectedTaskIndex = null;
                });
              },
            ),
          ] else ...[
            // IconButton(
            //   icon: const Icon(Icons.add),
            //   onPressed: _showAddTaskModal,
            // ),
          ],
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox!.listenable(),
        builder: (context, Box<Todo> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Todo task = box.getAt(index)!;
              return ListTile(
                leading: Icon(
                  selectedTaskIndex == index
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: selectedTaskIndex == index ? Colors.blue : null,
                ),
                title: Text(task.title),
                subtitle: Text(DateFormat('EEE, dd MMM').format(task.date)),
                onTap: () => _selectTask(index),
              );
            },
          );
        },
      ),
      floatingActionButton: selectedTaskIndex == null
          ? FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              onPressed: _showAddTaskModal,
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Set this to true if the modal should cover the entire screen height
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Perform actions or cleanup before the modal is popped, if necessary.
            // Return true to allow the modal to be popped, or false to prevent it.
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // This ensures that the modal is above the keyboard
            ),
            child: AddTaskModal(
              onAdd: (String title, DateTime date) {
                final Todo newTodo = Todo(title: title, date: date);
                todoBox!
                    .add(newTodo); // Use your Hive box to add the new todo item
                // Dismiss the modal bottom sheet after adding the item
              },
            ),
          ),
        );
      },
    );
  }
}

class AddTaskModal extends StatefulWidget {
  final Function(String, DateTime) onAdd;

  AddTaskModal({required this.onAdd});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
            autofocus: true,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(DateFormat('EEE, dd MMM').format(_selectedDate)),
              ),
              IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_month),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width / 1.2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shadowColor: Colors.transparent,
                // shape: Border.all(),
              ),
              child: Text(
                'Add Task',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                widget.onAdd(_titleController.text, _selectedDate);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskModall extends StatefulWidget {
  final Box<Todo> todoBox; // Pass the Hive box to the modal

  AddTaskModall({required this.todoBox});

  @override
  _AddTaskModallState createState() => _AddTaskModallState();
}

class _AddTaskModallState extends State<AddTaskModall> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _addTodo() {
    final String title = _titleController.text;
    final DateTime date =
        _selectedDate; // Use the selected date from the DatePicker
    final Todo newTodo = Todo(title: title, date: date);

    widget.todoBox.add(newTodo); // Save to Hive box
    _titleController.clear();
    Navigator.pop(context); // Close the modal after saving the task
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(DateFormat('EEE, dd MMM').format(_selectedDate)),
              ),
              IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_month),
              ),
            ],
          ),
          ElevatedButton(
            child: Text('Add Task'),
            onPressed: _addTodo, // Call the _addTodo method when pressed
          ),
        ],
      ),
    );
  }
}
