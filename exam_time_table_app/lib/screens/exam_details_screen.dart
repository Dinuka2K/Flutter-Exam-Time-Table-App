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
  final Color _primaryColor = const Color(0xFF6C63FF);
  final Color _secondaryColor = const Color(0xFF4A44B7);
  final Color _accentColor = const Color(0xFFFF6584);

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        title: Text(
          widget.isNew ? 'Create New Exam' : _currentExam.courseName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!widget.isNew)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Exam',
                        style: TextStyle(color: Colors.red)),
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.assignment, size: 40, color: _primaryColor),
                ),
              ),
              const SizedBox(height: 20),

              // Course Name Field
              _buildSectionHeader('Course Information'),
              _buildStyledTextField(
                label: 'Course Name',
                initialValue: _currentExam.courseName,
                icon: Icons.school,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(subject: value!),
              ),

              // Date and Time Row
              _buildSectionHeader('Exam Schedule'),
              Row(
                children: [
                  Expanded(
                    child: _buildStyledTextField(
                      label: 'Date (YYYY-MM-DD)',
                      initialValue: _currentExam.date,
                      icon: Icons.calendar_today,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _currentExam = _currentExam.copyWith(date: value!),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStyledTextField(
                      label: 'Time (HH:MM)',
                      initialValue: _currentExam.time,
                      icon: Icons.access_time,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a time';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _currentExam = _currentExam.copyWith(time: value!),
                    ),
                  ),
                ],
              ),

              // Location Field
              _buildStyledTextField(
                label: 'Location',
                initialValue: _currentExam.hall,
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _currentExam = _currentExam.copyWith(location: value!),
              ),

              // Description Field
              _buildSectionHeader('Additional Details'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _currentExam.description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    prefixIcon: Icon(Icons.description, color: _primaryColor),
                  ),
                  maxLines: 4,
                  style: TextStyle(color: Colors.grey[800]),
                  onSaved: (value) => _currentExam =
                      _currentExam.copyWith(description: value ?? ''),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExam,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _secondaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    required String? Function(String?) validator,
    required Function(String?) onSaved,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Icon(icon, color: _primaryColor),
        ),
        style: TextStyle(color: Colors.grey[800]),
        validator: validator,
        onSaved: onSaved,
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
      courseName: subject ?? courseName,
      date: date ?? this.date,
      time: time ?? this.time,
      hall: location ?? hall,
      description: description ?? this.description,
    );
  }
}
