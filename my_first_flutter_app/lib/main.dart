import 'package:flutter/material.dart';
import 'student_list_screen.dart';
import 'student_details_screen.dart';
import 'add_student_screen.dart';

void main() {
  profiles.sort((a, b) => a['name'].compareTo(b['name']));
  runApp(const MyApp());
}

List<Map<String, dynamic>> profiles = [
  {
    'image': 'assets/da.jfif',
    'name': "James Laurence C. Gulfan",
    'courseSection': "BSIT - 3",
    'age': 19,
    'hobby': "Basketball",
    'studentID': '24060149',
    'email': 'james@gmail.com',
    'favSubject': 'Programming',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/john.jfif',
    'name': "John Deacon",
    'courseSection': "BSIT - 3",
    'age': 23,
    'hobby': null,
    'studentID': '4932-1224',
    'email': 'john@gmail.com',
    'favSubject': 'Database',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/brian.jfif',
    'name': "Brian May",
    'courseSection': "BSIT - 3",
    'age': null,
    'hobby': "Sleeping",
    'studentID': '3003-2044',
    'email': 'brian@gmail.com',
    'favSubject': 'Web Development',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/fred.jfif',
    'name': "Fred Merc",
    'courseSection': "BSIT - 3",
    'age': 20,
    'hobby': "Singing",
    'studentID': '1302-6953',
    'email': null,
    'favSubject': 'Programming',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/roger.jfif',
    'name': "Roger Taylor",
    'courseSection': null,
    'age': 26,
    'hobby': "Dancing",
    'studentID': '2049-232',
    'email': 'roger@gmail.com',
    'favSubject': 'Networking',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/ds.webp',
    'name': "Tommy Shelby",
    'courseSection': "BSCS - 2",
    'age': 20,
    'hobby': "Basketball",
    'studentID': '2309-2060',
    'email': 'tommy@gmail.com',
    'favSubject': 'Cybersecurity',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/add-student': (context) => const AddStudentScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student-details') {
          final profile =
          settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) => StudentDetailsScreen(
              profile: profile,
            ),
          );
        }

        return null;
      },
    );
  }
}