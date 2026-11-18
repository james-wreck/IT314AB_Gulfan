
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'repositories/enrollment_repository.dart';
import 'repositories/grade_repository.dart';
import 'repositories/program_repository.dart';
import 'repositories/schedule_repository.dart';
import 'repositories/student_repository.dart';
import 'repositories/subject_repository.dart';

import 'viewmodels/enrollment_viewmodel.dart';
import 'viewmodels/grade_viewmodel.dart';
import 'viewmodels/schedule_viewmodel.dart';
import 'viewmodels/student_viewmodel.dart';
import 'viewmodels/subject_viewmodel.dart';

import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              StudentViewModel(StudentRepository(), ProgramRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(SubjectRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ScheduleViewModel(ScheduleRepository(), SubjectRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => EnrollmentViewModel(
            EnrollmentRepository(),
            StudentRepository(),
            ScheduleRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              GradeViewModel(GradeRepository(), EnrollmentRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
