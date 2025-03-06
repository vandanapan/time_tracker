import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _timeEntries = [];
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<TimeEntry> get timeEntries => _timeEntries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  TimeEntryProvider(this.storage) {
    _loadDataFromStorage();
    _initializeDefaults(); // Add default projects and tasks on initialization
  }

  void _loadDataFromStorage() async {
    var storedTimeEntries = await storage.getItem('timeEntries');
    var storedProjects = await storage.getItem('projects');
    var storedTasks = await storage.getItem('tasks');

    if (storedTimeEntries != null) {
      _timeEntries = List<TimeEntry>.from(
        (jsonDecode(storedTimeEntries) as List)
            .map((item) => TimeEntry.fromJson(item)),
      );
    }

    if (storedProjects != null) {
      _projects = List<Project>.from(
        (jsonDecode(storedProjects) as List)
            .map((item) => Project.fromJson(item)),
      );
    }

    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (jsonDecode(storedTasks) as List).map((item) => Task.fromJson(item)),
      );
    }

    notifyListeners();
  }

  void _initializeDefaults() {
    // Add default projects if none exist
    if (_projects.isEmpty) {
      _projects = [
        Project(id: '1', name: 'Project Alpha'),
        Project(id: '2', name: 'Project Beta'),
        Project(id: '3', name: 'Project Gamma'),
      ];
      print('Default projects added');
    }

    // Add default tasks if none exist
    if (_tasks.isEmpty) {
      _tasks = [
        Task(id: '1', name: 'Task A'),
        Task(id: '2', name: 'Task B'),
        Task(id: '3', name: 'Task C'),
      ];
      print('Default tasks added');
    }

    // Save defaults to local storage if necessary
    _saveDataToStorage();
    notifyListeners();
  }

  void addTimeEntry(TimeEntry timeEntry) {
    _timeEntries.add(timeEntry);
    _saveDataToStorage();
    notifyListeners();
  }

  void removeTimeEntry(String id) {
    _timeEntries.removeWhere((timeEntry) => timeEntry.id == id);
    _saveDataToStorage();
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    _saveDataToStorage();
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveDataToStorage();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveDataToStorage();
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveDataToStorage();
    notifyListeners();
  }

  void _saveDataToStorage() {
    final timeEntriesJson =
        jsonEncode(_timeEntries.map((e) => e.toJson()).toList());
    final projectsJson = jsonEncode(_projects.map((e) => e.toJson()).toList());
    final tasksJson = jsonEncode(_tasks.map((e) => e.toJson()).toList());

    print('Saving Time Entries: $timeEntriesJson');
    print('Saving Projects: $projectsJson');
    print('Saving Tasks: $tasksJson');

    storage.setItem('timeEntries', timeEntriesJson);
    storage.setItem('projects', projectsJson);
    storage.setItem('tasks', tasksJson);
  }
}