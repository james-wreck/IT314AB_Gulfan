import 'package:flutter/material.dart';
import 'enrollment_screen.dart';
import 'grade_screen.dart';
import 'schedule_screen.dart';
import 'student_list_screen.dart';
import 'subject_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _screens = <Widget>[
    StudentListScreen(),
    SubjectScreen(),
    ScheduleScreen(),
    EnrollmentScreen(),
    GradeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Only the selected screen is built, so each tab reloads fresh data
    // (for example slot counts) when you switch to it.
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Subjects'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Schedules'),
          NavigationDestination(icon: Icon(Icons.how_to_reg), label: 'Enroll'),
          NavigationDestination(icon: Icon(Icons.grade), label: 'Grades'),
        ],
      ),
    );
  }
}
