import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  Future<List<Subject>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('SELECT subject_id, subject_code, subject_name, units, '
          'description FROM "Subject" ORDER BY subject_code'),
    );
    return result.map((r) => Subject.fromRow(r.toColumnMap())).toList();
  }

  Future<void> insert(Subject s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO "Subject" '
          '(subject_code, subject_name, units, description) '
          'VALUES (@code, @name, @units, @description)'),
      parameters: {
        'code': s.subjectCode,
        'name': s.subjectName,
        'units': s.units,
        'description': s.description,
      },
    );
  }

  Future<void> update(Subject s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE "Subject" SET subject_code = @code, '
          'subject_name = @name, units = @units, description = @description '
          'WHERE subject_id = @id'),
      parameters: {
        'id': s.subjectId,
        'code': s.subjectCode,
        'name': s.subjectName,
        'units': s.units,
        'description': s.description,
      },
    );
  }

  Future<void> delete(int subjectId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM "Subject" WHERE subject_id = @id'),
      parameters: {'id': subjectId},
    );
  }
}
