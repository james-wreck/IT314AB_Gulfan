import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student_record.dart';

class StudentDetailsRepository {
  /// Every subject the student is enrolled in, with schedule and grade.
  Future<List<StudentRecord>> getRecords(int studentId) async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT su.subject_code, su.subject_name, su.units,
               sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time,
               sc.room, e.status,
               CAST(g.grade_value AS double precision) AS grade_value,
               g.remarks
        FROM "Enrollment" e
        JOIN "Subject" su ON su.subject_id = e.subject_id
        JOIN "Schedule" sc ON sc.schedule_id = e.schedule_id
        LEFT JOIN "Grades" g ON g.enrollment_id = e.enrollment_id
        WHERE e.student_id = @id
        ORDER BY su.subject_code
      '''),
      parameters: {'id': studentId},
    );
    return result.map((r) => StudentRecord.fromRow(r.toColumnMap())).toList();
  }
}
