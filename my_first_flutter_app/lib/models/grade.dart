class Grade {
  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String? remarks;
  final String? dateRecorded;

  // From JOINs, display only
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;

  Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    this.remarks,
    this.dateRecorded,
    this.studentName,
    this.subjectCode,
    this.subjectName,
  });

  factory Grade.fromRow(Map<String, dynamic> row) {
    return Grade(
      gradeId: row['grade_id'] as int,
      enrollmentId: row['enrollment_id'] as int,
      // the SQL casts numeric to double precision, so this is a num
      gradeValue: (row['grade_value'] as num).toDouble(),
      remarks: row['remarks'] as String?,
      dateRecorded: row['date_recorded'] as String?,
      studentName: row['student_name'] as String?,
      subjectCode: row['subject_code'] as String?,
      subjectName: row['subject_name'] as String?,
    );
  }
}
