class Student {
  final int? studentId;
  final String studentName;
  final int? programId;
  final String? programName; // from JOIN, display only

  Student({
    this.studentId,
    required this.studentName,
    this.programId,
    this.programName,
  });

  factory Student.fromRow(Map<String, dynamic> row) {
    return Student(
      studentId: row['student_id'] as int,
      studentName: row['student_name'] as String,
      programId: row['program_id'] as int?,
      programName: row['program_name'] as String?,
    );
  }
}
