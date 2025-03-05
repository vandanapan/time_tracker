class Project {
  final String id;
  final String name;

  Project({required this.id, required this.name});
}

class Task {
  final String id;
  final String name;

  Task({required this.id, required this.name});
}

class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });
}