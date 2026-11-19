/// One subject a student is enrolled in, with its schedule and grade (if any).
class StudentRecord {
  final String subjectCode;
  final String subjectName;
  final int units;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final String status;
  final double? gradeValue;
  final String? remarks;

  StudentRecord({
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.status,
    this.gradeValue,
    this.remarks,
  });

  factory StudentRecord.fromRow(Map<String, dynamic> row) {
    return StudentRecord(
      subjectCode: row['subject_code'] as String,
      subjectName: row['subject_name'] as String,
      units: row['units'] as int,
      dayOfWeek: row['day_of_week'] as String,
      startTime: row['start_time'] as String,
      endTime: row['end_time'] as String,
      room: row['room'] as String,
      status: row['status'] as String,
      gradeValue: (row['grade_value'] as num?)?.toDouble(),
      remarks: row['remarks'] as String?,
    );
  }
}
