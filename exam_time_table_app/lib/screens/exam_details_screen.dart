import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../services/exam_service.dart';

class ExamDetailScreen extends StatefulWidget {
  final Exam exam;
  final ExamService examService;
  final bool isNew;

  const ExamDetailScreen({
    super.key,
    required this.exam,
    required this.examService,
    this.isNew = false,
  });

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  late Exam _currentExam;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentExam = widget.exam;
  }

  Future<void> _saveExam() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.isNew) {
        await widget.examService.addExams(_currentExam);
      } else {
        await widget.examService.updateExam(_currentExam);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _deleteExam() async {
    if (!widget.isNew) {
      await widget.examService.deleteExam(_currentExam.cid);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Add New Exam' : _currentExam.courseName),
        actions: [
          if (!widget.isNew)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Exam'),
                    content: const Text(
                        'Are you sure you want to delete this exam?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteExam();
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _currentExam.courseName,
                decoration: const InputDecoration(labelText: 'Cource Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Course Name';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(subject: value!),
              ),
              TextFormField(
                initialValue: _currentExam.date,
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(date: value!),
              ),
              TextFormField(
                initialValue: _currentExam.time,
                decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(time: value!),
              ),
              TextFormField(
                initialValue: _currentExam.hall,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(location: value!),
              ),
              TextFormField(
                initialValue: _currentExam.description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _currentExam =
                    _currentExam.copyWith(description: value ?? ''),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {}, //_saveExam,
                child: const Text('Save Exam'),
=======

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, // _saveExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: _primaryColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    'SAVE EXAM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
>>>>>>> Stashed changes
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ExamCopyWith on Exam {
  Exam copyWith({
    String? id,
    String? subject,
    String? date,
    String? time,
    String? location,
    String? description,
  }) {
    return Exam(
      cid: id ?? cid,
      courseName: courseName,
      date: date ?? this.date,
      time: time ?? this.time,
      hall: location ?? hall,
      description: description ?? this.description,
    );
  }
}
