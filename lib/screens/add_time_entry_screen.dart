import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialTimeEntry;

  const AddTimeEntryScreen({Key? key, this.initialTimeEntry}) : super(key: key);

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _totalTimeController;
  late TextEditingController _noteController;
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _totalTimeController = TextEditingController(
      text: widget.initialTimeEntry?.totalTime.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.initialTimeEntry?.note ?? '',
    );
    _selectedProjectId = widget.initialTimeEntry?.projectId;
    _selectedTaskId = widget.initialTimeEntry?.taskId;
    _selectedDate = widget.initialTimeEntry?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTimeEntry == null
            ? 'Add Time Entry'
            : 'Edit Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Project dropdown
            DropdownButtonFormField<String>(
              value: _selectedProjectId,
              decoration: InputDecoration(
                labelText: 'Project',
                labelStyle: TextStyle(color: Colors.black),
              ),
              items: provider.projects
                  .map((project) => DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(project.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProjectId = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Task dropdown
            DropdownButtonFormField<String>(
              value: _selectedTaskId,
              decoration: InputDecoration(
                labelText: 'Task',
                labelStyle: TextStyle(color: Colors.black),
              ),
              items: provider.tasks
                  .map((task) => DropdownMenuItem<String>(
                        value: task.id,
                        child: Text(task.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTaskId = value;
                });
              },
            ),
            SizedBox(height: 16.0),

            // Date picker
            Text(
              'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 16.0),
            ),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text('Select Date'),
            ),
            SizedBox(height: 16.0),

            // Total time input
            TextField(
              controller: _totalTimeController,
              decoration: InputDecoration(
                labelText: 'Total Time (in hours)',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),

            // Note input
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: () => _saveTimeEntry(context),
              child: Text('Save Time Entry'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _saveTimeEntry(BuildContext context) {
    if (_selectedProjectId == null || _selectedTaskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a project and task')),
      );
      return;
    }

    final timeEntry = TimeEntry(
      id: widget.initialTimeEntry?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: _selectedProjectId!,
      taskId: _selectedTaskId!,
      totalTime: double.tryParse(_totalTimeController.text) ?? 0.0,
      date: _selectedDate,
      note: _noteController.text,
    );

    final provider = Provider.of<TimeEntryProvider>(context, listen: false);
    provider.addTimeEntry(timeEntry);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _totalTimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}