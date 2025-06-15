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
  final Color _primaryColor = const Color(0xFF6C63FF);
  final Color _secondaryColor = const Color(0xFF4A44B7);
  final Color _accentColor = const Color(0xFFFF6584);

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        title: const Text(
          'Exam Timetable',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _refreshExams,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<Exam>>(
        future: _examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _primaryColor),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading exams',
                style: TextStyle(color: _accentColor, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No exams scheduled yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first exam',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final exams = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: _primaryColor,
                    ),
                  ),
                  title: Text(
                    exam.courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${exam.date} • ${exam.time}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: _accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            exam.hall,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: _primaryColor,
                  ),
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
        backgroundColor: _primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newExam = Exam(
            cid: '',
            courseName: '',
            date: '',
            time: '',
            hall: '',
            description: '',
          );

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
