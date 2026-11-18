import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';

class StudentRepository {
  Future<List<Student>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT s.student_id, s.student_name, s.program_id, p.program_name
        FROM "Students" s
        LEFT JOIN "Program" p ON p.program_id = s.program_id
        ORDER BY s.student_name
      '''),
    );
    return result.map((r) => Student.fromRow(r.toColumnMap())).toList();
  }

  Future<void> insert(Student student) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO "Students" (student_id, student_name, program_id) '
          'VALUES (@id, @name, @programId)'),
      parameters: {
        'id': student.studentId,
        'name': student.studentName,
        'programId': student.programId,
      },
    );
  }

  Future<void> update(Student student) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE "Students" SET student_name = @name, '
          'program_id = @programId WHERE student_id = @id'),
      parameters: {
        'id': student.studentId,
        'name': student.studentName,
        'programId': student.programId,
      },
    );
  }

  Future<void> delete(int studentId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM "Students" WHERE student_id = @id'),
      parameters: {'id': studentId},
    );
  }
}
