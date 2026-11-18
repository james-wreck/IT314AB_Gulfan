import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/grade.dart';

class GradeRepository {
  Future<List<Grade>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT g.grade_id, g.enrollment_id, st.student_name,
               su.subject_code, su.subject_name,
               CAST(g.grade_value AS double precision) AS grade_value,
               g.remarks,
               to_char(g.date_recorded, 'YYYY-MM-DD HH24:MI') AS date_recorded
        FROM "Grades" g
        JOIN "Enrollment" e ON e.enrollment_id = g.enrollment_id
        JOIN "Students" st ON st.student_id = e.student_id
        JOIN "Subject" su ON su.subject_id = e.subject_id
        ORDER BY st.student_name, su.subject_code
      '''),
    );
    return result.map((r) => Grade.fromRow(r.toColumnMap())).toList();
  }

  Future<void> insert(Grade g) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO "Grades" (enrollment_id, grade_value, remarks) '
          'VALUES (@enrollmentId, '
          'CAST(CAST(@gradeValue AS text) AS numeric), @remarks)'),
      parameters: {
        'enrollmentId': g.enrollmentId,
        'gradeValue': g.gradeValue.toString(),
        'remarks': g.remarks,
      },
    );
  }

  Future<void> update(Grade g) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE "Grades" '
          'SET grade_value = CAST(CAST(@gradeValue AS text) AS numeric), '
          'remarks = @remarks, date_recorded = CURRENT_TIMESTAMP '
          'WHERE grade_id = @id'),
      parameters: {
        'id': g.gradeId,
        'gradeValue': g.gradeValue.toString(),
        'remarks': g.remarks,
      },
    );
  }

  Future<void> delete(int gradeId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM "Grades" WHERE grade_id = @id'),
      parameters: {'id': gradeId},
    );
  }
}
