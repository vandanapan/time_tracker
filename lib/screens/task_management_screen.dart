import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../models/task.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Tasks"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.removeTask(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final taskName = await showDialog<String>(
            context: context,
            builder: (context) => AddTaskDialog(),
          );
          if (taskName != null && taskName.isNotEmpty) {
            final newTask = Task(id: DateTime.now().toString(), name: taskName);
            Provider.of<TimeEntryProvider>(context, listen: false).addTask(newTask);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}