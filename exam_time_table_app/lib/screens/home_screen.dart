import 'package:exam_time_table_app/models/exam.dart';
import 'package:exam_time_table_app/screens/exam_details_screen.dart';
import 'package:exam_time_table_app/services/exam_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExamService _examService = ExamService();
  late Future<List<Exam>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _examsFuture = _examService.getExams();
  }

  void _refreshExams() {
    setState(() {
      _examsFuture = _examService.getExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Timetable'),
        actions: [
          IconButton(
            onPressed: _refreshExams,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Exam>>(
        future: _examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exams found'));
          }

          final exams = snapshot.data!;

          return ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    exam.courseName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${exam.date} at ${exam.time}\n${exam.hall}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetailScreen(
                          exam: exam,
                          examService: _examService,
                        ),
                      ),
                    );
                    _refreshExams();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newExam = Exam(
              cid: 'ICT4122',
              courseName: 'Mobile Application Development',
              date: '2025-06-17',
              time: '09:00',
              hall: 'ICT Lab',
              description: 'Practical and Theory Exam');

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamDetailScreen(
                exam: newExam,
                examService: _examService,
                isNew: true,
              ),
            ),
          );
          _refreshExams();
        },
      ),
    );
  }
}
