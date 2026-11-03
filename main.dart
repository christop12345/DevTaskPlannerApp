import 'package:flutter/material.dart';

void main() {
  runApp(const DevTaskPlannerApp());
}

class DevTaskPlannerApp extends StatelessWidget {
  const DevTaskPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Task Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskItem {
  final String id;
  final String title;
  final String category;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<TaskItem> _tasks = [
    TaskItem(id: '1', title: 'Setup GitHub Actions CI/CD Pipeline', category: 'DevOps'),
    TaskItem(id: '2', title: 'Write unit tests for Authentication Service', category: 'Testing'),
    TaskItem(id: '3', title: 'Implement Method Channels for Native Android', category: 'Flutter'),
  ];

  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Flutter';

  void _addTask() {
    if (_textController.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(TaskItem(
        id: DateTime.now().toString(),
        title: _textController.text.trim(),
        category: _selectedCategory,
      ));
      _textController.clear();
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprint & Task Planner'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: const Icon(Icons.check_circle_outline, size: 18, color: Colors.indigoAccent),
              label: Text(
                '$completedCount / ${_tasks.length} Done',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.indigo.withOpacity(0.2),
              side: const BorderSide(color: Colors.indigoAccent),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            labelText: 'New Task Title',
                            hintText: 'e.g. Refactor API layer',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _addTask(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _selectedCategory,
                        items: ['Flutter', 'DevOps', 'Testing', 'Backend']
                            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _addTask,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks in sprint. Add your first item above!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) => _toggleTask(task.id),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  color: task.isCompleted ? Colors.grey : Colors.white,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(
                                      task.category,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.pink),
                                    onPressed: () => _deleteTask(task.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}