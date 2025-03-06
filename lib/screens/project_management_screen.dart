import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../models/project.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Projects"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.removeProject(project.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final projectName = await showDialog<String>(
            context: context,
            builder: (context) => AddProjectDialog(),
          );
          if (projectName != null && projectName.isNotEmpty) {
            final newProject = Project(id: DateTime.now().toString(), name: projectName);
            Provider.of<TimeEntryProvider>(context, listen: false).addProject(newProject);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}