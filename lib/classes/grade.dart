import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course.dart';

enum GradeFormat { format15, format6 }

enum GradeType { test, exam }

class Grade {
  String title;
  Course course;
  int grade;
  GradeFormat format;
  DateTime date;
  GradeType type;

  Grade({
    required this.title,
    required this.course,
    required this.grade,
    required this.format,
    required this.date,
    required this.type,
  });

  List<Widget> get _details {
    return [
      ListTile(
        leading: Icon(
          Icons.school,
          color: course.color,
        ),
        title: Text(course.displayName),
      ),
      ListTile(
        leading: const Icon(Icons.star),
        title: Text("$grade"),
      ),
      ListTile(
        leading: const Icon(Icons.event),
        title: Text(DateFormat('EEEE, d. MMMM yyyy', 'de').format(date)),
      ),
      ListTile(
        leading: const Icon(Icons.text_fields),
        title: Text(type.name),
      ),
    ];
  }

  Widget listTile(BuildContext context, List<Widget> actions) {
    return ListTile(
      onTap: () => showMCGBottomSheet(context, title, _details, actions),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            course.displayName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('EEEE, d. MMMM yyyy', 'de').format(date),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: course.color,
        child: Text(
          course.short,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      trailing: Text(
        "$grade",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

final List<int> gradeEntries = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

List<Grade> grades = [];

void sortGrades() {
  grades.sort((a, b) =>
      int.parse(DateFormat('yyyyMMdd').format(b.date)).compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
}

void addGrade(Grade grade) {
  grades.add(grade);
  sortGrades();
  saveGrades();
}

void removeGrade(Grade grade) {
  grades.remove(grade);
  saveGrades();
}

void editGrade(Grade before, Grade after) {
  grades.insert(grades.indexOf(before), after);
  grades.remove(before);
  sortGrades();
  saveGrades();
}

Future<void> saveGrades() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedGrades = [];
  for (Grade grade in grades) {
    encodedGrades
        .add('${grade.title}|${grade.course.title}|${grade.grade}|${DateFormat('yyyy-MM-dd').format(grade.date)}');
  }
  prefs.setStringList('grades', encodedGrades);
}

Future<void> loadGrades() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedGrades = prefs.getStringList('grades') ?? [];
  List<Grade> decodedGrades = [];
  for (String encodedGrade in encodedGrades) {
    List<String> gradeParameters = encodedGrade.split('|');
    decodedGrades.add(Grade(
      title: gradeParameters[0],
      course: Course.fromTitle(gradeParameters[1])!,
      format: GradeFormat.format15,
      grade: int.parse(gradeParameters[2]),
      date: DateTime.parse(gradeParameters[3]),
      type: GradeType.test,
    ));
  }
  grades = decodedGrades;
}