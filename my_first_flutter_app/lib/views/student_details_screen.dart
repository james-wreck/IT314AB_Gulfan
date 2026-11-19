import 'package:flutter/material.dart';
import '../core/db_error.dart';
import '../models/student.dart';
import '../models/student_record.dart';
import '../repositories/student_details_repository.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _repo = StudentDetailsRepository();
  late Future<List<StudentRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getRecords(widget.student.studentId!);
  }

  void _reload() {
    setState(() {
      _future = _repo.getRecords(widget.student.studentId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<StudentRecord>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      dbErrorMessage(snap.error!),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final records = snap.data ?? [];
          final active = records.where((r) => r.status == 'Enrolled');
          final totalUnits = active.fold<int>(0, (sum, r) => sum + r.units);
          final graded = records.where((r) => r.gradeValue != null).toList();
          final average = graded.isEmpty
              ? null
              : graded.map((r) => r.gradeValue!).reduce((a, b) => a + b) /
                    graded.length;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.studentName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Student ID: ${s.studentId}'),
                      Text('Program: ${s.programName ?? 'No program'}'),
                      const Divider(height: 24),
                      Text('Subjects enrolled: ${active.length}'),
                      Text('Total units: $totalUnits'),
                      Text(
                        'Average grade: '
                        '${average == null ? '-' : average.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: Text(
                  'Subjects and grades',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (records.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('Not enrolled in any subject yet')),
                ),
              for (final r in records)
                Card(
                  child: ListTile(
                    isThreeLine: true,
                    title: Text('${r.subjectCode} - ${r.subjectName}'),
                    subtitle: Text(
                      '${r.units} unit(s) | ${r.status}\n'
                      '${r.dayOfWeek} ${r.startTime}-${r.endTime} | '
                      'Room ${r.room}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Grade', style: TextStyle(fontSize: 11)),
                        Text(
                          r.gradeValue == null
                              ? '-'
                              : r.gradeValue!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
