import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'student_details_screen.dart';
import 'student_form_screen.dart';
import 'widgets/common.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StudentViewModel>().load();
    });
  }

  Future<void> _openForm([Student? student]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: student)),
    );
  }

  Future<void> _delete(Student s) async {
    if (!await confirmDelete(context, s.studentName)) return;
    if (!mounted) return;
    final error =
        await context.read<StudentViewModel>().removeStudent(s.studentId!);
    if (error != null && mounted) showMessage(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Students'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        isLoading: vm.isLoading,
        errorMessage: vm.errorMessage,
        isEmpty: vm.students.isEmpty,
        emptyText: 'No students found',
        onRetry: vm.load,
        child: ListView.builder(
          itemCount: vm.students.length,
          itemBuilder: (context, i) {
            final s = vm.students[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentDetailsScreen(student: s),
                  ),
                ),
                title: Text(s.studentName),
                subtitle: Text(
                    'ID: ${s.studentId} | ${s.programName ?? 'No program'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(s),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
