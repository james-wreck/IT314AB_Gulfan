class Enrollment {
  final int? enrollmentId;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final String? enrolledAt;
  final String status;

  // From JOINs, display only
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final String? room;

  Enrollment({
    this.enrollmentId,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.enrolledAt,
    this.status = 'Enrolled',
    this.studentName,
    this.subjectCode,
    this.subjectName,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.room,
  });

  String get label => '$studentName - $subjectCode';

  factory Enrollment.fromRow(Map<String, dynamic> row) {
    return Enrollment(
      enrollmentId: row['enrollment_id'] as int,
      studentId: row['student_id'] as int,
      subjectId: row['subject_id'] as int,
      scheduleId: row['schedule_id'] as int,
      enrolledAt: row['enrolled_at'] as String?,
      status: row['status'] as String,
      studentName: row['student_name'] as String?,
      subjectCode: row['subject_code'] as String?,
      subjectName: row['subject_name'] as String?,
      dayOfWeek: row['day_of_week'] as String?,
      startTime: row['start_time'] as String?,
      endTime: row['end_time'] as String?,
      room: row['room'] as String?,
    );
  }
}
