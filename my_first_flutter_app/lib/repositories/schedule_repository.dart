import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  Future<List<Schedule>> getAll() async {
    final conn = await DbConnection.get();
    final result = await conn.execute(
      Sql.named('''
        SELECT sc.schedule_id, sc.subject_id, su.subject_code, su.subject_name,
               sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time,
               sc.room, sc.slot_capacity,
               (SELECT COUNT(*) FROM "Enrollment" e
                 WHERE e.schedule_id = sc.schedule_id
                   AND e.status = 'Enrolled')::int AS enrolled_count
        FROM "Schedule" sc
        JOIN "Subject" su ON su.subject_id = sc.subject_id
        ORDER BY su.subject_code, sc.day_of_week, sc.start_time
      '''),
    );
    return result.map((r) => Schedule.fromRow(r.toColumnMap())).toList();
  }

  Future<void> insert(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('''
        INSERT INTO "Schedule"
          (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
        VALUES
          (@subjectId, @day, CAST(CAST(@startTime AS text) AS time),
           CAST(CAST(@endTime AS text) AS time), @room, @capacity)
      '''),
      parameters: {
        'subjectId': s.subjectId,
        'day': s.dayOfWeek,
        'startTime': s.startTime,
        'endTime': s.endTime,
        'room': s.room,
        'capacity': s.slotCapacity,
      },
    );
  }

  Future<void> update(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('''
        UPDATE "Schedule"
        SET subject_id = @subjectId, day_of_week = @day,
            start_time = CAST(CAST(@startTime AS text) AS time),
            end_time = CAST(CAST(@endTime AS text) AS time),
            room = @room, slot_capacity = @capacity
        WHERE schedule_id = @id
      '''),
      parameters: {
        'id': s.scheduleId,
        'subjectId': s.subjectId,
        'day': s.dayOfWeek,
        'startTime': s.startTime,
        'endTime': s.endTime,
        'room': s.room,
        'capacity': s.slotCapacity,
      },
    );
  }

  Future<void> delete(int scheduleId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('DELETE FROM "Schedule" WHERE schedule_id = @id'),
      parameters: {'id': scheduleId},
    );
  }
}
