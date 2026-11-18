import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/enrollment.dart';
import '../models/schedule.dart';

class EnrollmentRepository {
  Future<List<Enrollment>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT e.enrollment_id, e.student_id, st.student_name,
               e.subject_id, su.subject_code, su.subject_name,
               e.schedule_id, sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time,
               sc.room,
               to_char(e.enrolled_at, 'YYYY-MM-DD HH24:MI') AS enrolled_at,
               e.status
        FROM "Enrollment" e
        JOIN "Students" st ON st.student_id = e.student_id
        JOIN "Subject" su ON su.subject_id = e.subject_id
        JOIN "Schedule" sc ON sc.schedule_id = e.schedule_id
        ORDER BY st.student_name, su.subject_code
      '''),
    );
    return result.map((r) => Enrollment.fromRow(r.toColumnMap())).toList();
  }

  // ---- Validation queries. excludeId = the enrollment being edited. ----

  /// True if the student already has a record for this subject.
  Future<bool> isDuplicate(int studentId, int subjectId,
      {int? excludeId}) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('SELECT 1 FROM "Enrollment" '
          'WHERE student_id = @student AND subject_id = @subject '
          'AND enrollment_id <> @exclude'),
      parameters: {
        'student': studentId,
        'subject': subjectId,
        'exclude': excludeId ?? -1,
      },
    );
    return r.isNotEmpty;
  }

  /// How many ACTIVE students are enrolled in this schedule.
  Future<int> countForSchedule(int scheduleId, {int? excludeId}) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('SELECT COUNT(*) FROM "Enrollment" '
          'WHERE schedule_id = @schedule AND enrollment_id <> @exclude '
          "AND status = 'Enrolled'"),
      parameters: {'schedule': scheduleId, 'exclude': excludeId ?? -1},
    );
    return r.first[0] as int;
  }

  /// Returns a description of an overlapping class, or null if none.
  /// Two time ranges overlap when: existing.start < new.end AND existing.end > new.start
  Future<String?> findConflict(int studentId, Schedule s,
      {int? excludeId}) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('''
        SELECT su.subject_code, sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time
        FROM "Enrollment" e
        JOIN "Schedule" sc ON sc.schedule_id = e.schedule_id
        JOIN "Subject" su ON su.subject_id = e.subject_id
        WHERE e.student_id = @student
          AND e.enrollment_id <> @exclude
          AND e.status = 'Enrolled'
          AND sc.day_of_week = @day
          AND sc.start_time < CAST(CAST(@newEnd AS text) AS time)
          AND sc.end_time > CAST(CAST(@newStart AS text) AS time)
        LIMIT 1
      '''),
      parameters: {
        'student': studentId,
        'exclude': excludeId ?? -1,
        'day': s.dayOfWeek,
        'newStart': s.startTime,
        'newEnd': s.endTime,
      },
    );
    if (r.isEmpty) return null;
    final m = r.first.toColumnMap();
    return '${m['subject_code']} '
        '(${m['day_of_week']} ${m['start_time']}-${m['end_time']})';
  }

  // ---- Writes. status and enrolled_at use the database defaults on insert. ----

  Future<void> insert(int studentId, Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO "Enrollment" '
          '(student_id, subject_id, schedule_id) '
          'VALUES (@student, @subject, @schedule)'),
      parameters: {
        'student': studentId,
        'subject': s.subjectId,
        'schedule': s.scheduleId,
      },
    );
  }

  Future<void> update(int enrollmentId, Schedule s, String status) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE "Enrollment" '
          'SET subject_id = @subject, schedule_id = @schedule, '
          'status = @status '
          'WHERE enrollment_id = @id'),
      parameters: {
        'id': enrollmentId,
        'subject': s.subjectId,
        'schedule': s.scheduleId,
        'status': status,
      },
    );
  }

  Future<void> delete(int enrollmentId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM "Enrollment" WHERE enrollment_id = @id'),
      parameters: {'id': enrollmentId},
    );
  }
}
