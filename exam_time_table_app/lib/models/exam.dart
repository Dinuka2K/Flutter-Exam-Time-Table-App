class Exam {
  final String cid;
  final String courseName;
  final String date;
  final String time;
  final String hall;
  final String description;

  Exam(
      {required this.cid,
      required this.courseName,
      required this.date,
      required this.time,
      required this.hall,
      required this.description});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      cid: json['cid'],
      courseName: json['courseName'],
      date: json['date'],
      time: json['time'],
      hall: json['hall'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'courseName': courseName,
      'date': date,
      'time': time,
      'hall': hall,
      'description': description
    };
  }
}
