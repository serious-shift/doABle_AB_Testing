import 'package:doable_ab_testing/src/core/services/remote_config_service.dart';
import 'package:flutter/material.dart';

import '../../../widgets/todo_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final _remoteConfig = RemoteConfigService();

  Color _getThemeColor(String colorName) {
    switch (colorName) {
      case 'purple':
        return Color(0xFF9C27B0);
      case 'deep_purple':
        return Color(0xFF673AB7);
      case 'blue':
      default:
        return Color(0xFF0D47A1);
    }
  }

  void _addTodo() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _todos.add(Todo(id: DateTime.now().toString(), title: _controller.text));
    });

    _controller.clear();
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _clearAll() {
    setState(() {
      _todos.removeWhere((todo) => todo.isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String colorString = _remoteConfig.primaryColorString;
    final Color primaryColor = _getThemeColor(colorString);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase ToDo List Demo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () async {
            await RemoteConfigService().fetchAndActivate();
            setState(() {});
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Actimelisiert!")));
            }
          },
          icon: Icon(Icons.refresh, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _todos.isEmpty
                ? const Center(child: Text("Keine Aufgaben vorhanden"))
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (ctx, index) {
                      final todo = _todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => _toggleTodo(index),
                          activeColor: primaryColor,
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isDone ? Colors.grey : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Neue Aufgabe",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    labelStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _addTodo,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primaryColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Hinzufügen",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(onPressed: _clearAll, icon: Icon(Icons.delete)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
