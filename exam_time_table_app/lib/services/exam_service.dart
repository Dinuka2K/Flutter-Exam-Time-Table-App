import 'dart:io';

import 'package:exam_time_table_app/models/exam.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class ExamService {
  static const String _jsonPath = 'assets/exams.json';

  Future<List<Exam>> getExams() async {
    final String responce = await rootBundle.loadString(_jsonPath);
    final data = await json.decode(responce) as List;
    return data.map((exam) => Exam.fromJson(exam)).toList();
  }

  /*Future<void> _saveExams(List<Exam> exams) async {
    final file = File('assets/exams.json');
    await file.writeAsString(json.encode(exams));
  }*/
  Future<void> _saveExams(List<Exam> exams) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/exams.json';
    final file = File(path);

    await file.writeAsString(json.encode(exams));
  }

  Future<void> addExams(Exam newExam) async {
    final exams = await getExams();
    exams.add(newExam);
    await _saveExams(exams);
  }

  Future<void> updateExam(Exam updatedExam) async {
    final exams = await getExams();
    final index = exams.indexWhere((exam) => exam.cid == updatedExam.cid);
    if (index != -1) {
      exams[index] = updatedExam;
      await _saveExams(exams);
    }
  }

  Future<void> deleteExam(String id) async {
    final exams = await getExams();
    exams.removeWhere((exam) => exam.cid == id);
    await _saveExams(exams);
  }
}
