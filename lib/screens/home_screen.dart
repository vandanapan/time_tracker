import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import 'project_management_screen.dart'; // Add this screen for managing projects
import 'task_management_screen.dart'; // Add this screen for managing tasks

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: All Entries, Grouped by Projects
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Tracking'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
            indicatorColor:
                Colors.amber, // Underline color for the selected tab
            indicatorWeight: 4.0, // Thickness of the underline
            labelColor: Colors.white, // Text color of the selected tab
            unselectedLabelColor:
                Colors.black54, // Text color of unselected tabs
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold), // Style for the selected tab text
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal), // Style for unselected tab text
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Projects'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProjectManagementScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Tasks'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskManagementScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: All Entries
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.timeEntries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 80.0,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Tap the + button to add your first entry.',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.timeEntries.length,
                  itemBuilder: (context, index) {
                    final timeEntry = provider.timeEntries[index];

                    // Fetch the project and task names safely
                    final project = provider.projects.firstWhere(
                      (project) => project.id == timeEntry.projectId,
                      orElse: () =>
                          Project(id: 'unknown', name: 'Unknown Project'),
                    );
                    final task = provider.tasks.firstWhere(
                      (task) => task.id == timeEntry.taskId,
                      orElse: () => Task(id: 'unknown', name: 'Unknown Task'),
                    );

                    final projectName = project.name;
                    final taskName = task.name;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          '$projectName - $taskName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.teal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Text(
                              'Total Time: ${timeEntry.totalTime} hours',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
                            ),
                            Text(
                              'Date: ${DateFormat.yMMMd().format(timeEntry.date)}',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            Text(
                              'Note: ${timeEntry.note}',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeTimeEntry(timeEntry.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Time entry deleted')),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTimeEntryScreen(
                                  initialTimeEntry: timeEntry),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            // Tab 2: Grouped by Projects
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.timeEntries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 80.0,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'No time entries yet!',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Tap the + button to add your first entry.',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                // Group entries by project
                final Map<String, List<TimeEntry>> groupedEntries = {};
                for (var entry in provider.timeEntries) {
                  if (!groupedEntries.containsKey(entry.projectId)) {
                    groupedEntries[entry.projectId] = [];
                  }
                  groupedEntries[entry.projectId]?.add(entry);
                }

                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: groupedEntries.entries.map((entry) {
                    final project = provider.projects.firstWhere(
                      (project) => project.id == entry.key,
                      orElse: () =>
                          Project(id: 'unknown', name: 'Unknown Project'),
                    );
                    final projectName = project.name;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              projectName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ...entry.value.map((timeEntry) {
                              final task = provider.tasks.firstWhere(
                                (task) => task.id == timeEntry.taskId,
                                orElse: () =>
                                    Task(id: 'unknown', name: 'Unknown Task'),
                              );
                              final taskName = task.name;

                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '- $taskName: ${timeEntry.totalTime} hours (${DateFormat.yMMMd().format(timeEntry.date)})',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black87),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTimeEntryScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Time Entry',
        ),
      ),
    );
  }
}
