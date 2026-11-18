class Schedule {
  final int? scheduleId;
  final int subjectId;
  final String? subjectCode; // from JOIN, display only
  final String? subjectName; // from JOIN, display only
  final String dayOfWeek;
  final String startTime; // 'HH:MM' text
  final String endTime; // 'HH:MM' text
  final String room;
  final int slotCapacity;
  final int enrolledCount; // from subquery, display only

  Schedule({
    this.scheduleId,
    required this.subjectId,
    this.subjectCode,
    this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
    this.enrolledCount = 0,
  });

  int get slotsLeft => slotCapacity - enrolledCount;

  String get label =>
      '$subjectCode | $dayOfWeek $startTime-$endTime | $room | '
      '$slotsLeft/$slotCapacity slots left';

  factory Schedule.fromRow(Map<String, dynamic> row) {
    return Schedule(
      scheduleId: row['schedule_id'] as int,
      subjectId: row['subject_id'] as int,
      subjectCode: row['subject_code'] as String?,
      subjectName: row['subject_name'] as String?,
      dayOfWeek: row['day_of_week'] as String,
      startTime: row['start_time'] as String,
      endTime: row['end_time'] as String,
      room: row['room'] as String,
      slotCapacity: row['slot_capacity'] as int,
      enrolledCount: row['enrolled_count'] as int,
    );
  }
}