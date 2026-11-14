import 'package:flutter/material.dart';
import 'student_data.dart';
import 'student_list_screen.dart';
import 'student_details_screen.dart';
import 'add_student_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved student records before the app starts.
  await loadProfiles();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter Application',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const StudentListScreen(),
        '/add': (context) => const AddStudentScreen(),
        '/details': (context) {
          final profile = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return StudentDetailsScreen(profile: profile);
        },
      },
    );
  }
}