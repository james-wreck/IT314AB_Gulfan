import '../core/base_viewmodel.dart';
import '../core/db_error.dart';
import '../models/enrollment.dart';
import '../models/schedule.dart';
import '../models/student.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/student_repository.dart';

class EnrollmentViewModel extends BaseViewModel {
  final EnrollmentRepository _repo;
  final StudentRepository _students;
  final ScheduleRepository _schedules;
  EnrollmentViewModel(this._repo, this._students, this._schedules);

  List<Enrollment> enrollments = [];
  List<Student> students = []; // for the student dropdown
  List<Schedule> schedules = []; // for the schedule dropdown

  Future<void> _refresh() async {
    enrollments = await _repo.getAll();
    schedules = await _schedules.getAll(); // refreshes the slot counts
  }

  Future<void> load() => runLoad(() async {
        await _refresh();
        students = await _students.getAll();
      });

  /// Throws a ValidationException if the enrollment is not allowed.
  Future<void> _validate(int studentId, Schedule schedule,
      {int? excludeId}) async {
    // 1. Duplicate: same student, same subject
    if (await _repo.isDuplicate(studentId, schedule.subjectId,
        excludeId: excludeId)) {
      throw ValidationException(
          'This student already has an enrollment record for this subject.');
    }

    // 2. Remaining slots (only 'Enrolled' counts)
    final taken = await _repo.countForSchedule(schedule.scheduleId!,
        excludeId: excludeId);
    if (taken >= schedule.slotCapacity) {
      throw ValidationException(
          'No slots left for this schedule ($taken/${schedule.slotCapacity}).');
    }

    // 3. Schedule conflict: same student, same day, overlapping time
    final conflict =
        await _repo.findConflict(studentId, schedule, excludeId: excludeId);
    if (conflict != null) {
      throw ValidationException('Schedule conflict with $conflict.');
    }
  }

  Future<String?> add(int studentId, Schedule schedule) => runAction(
        () async {
          await _validate(studentId, schedule);
          await _repo.insert(studentId, schedule);
        },
        _refresh,
        duplicate: 'This student already has an enrollment record for this '
            'subject.',
      );

  Future<String?> update(
          int enrollmentId, int studentId, Schedule schedule, String status) =>
      runAction(
        () async {
          // Dropping does not need a slot or conflict check.
          if (status == 'Enrolled') {
            await _validate(studentId, schedule, excludeId: enrollmentId);
          }
          await _repo.update(enrollmentId, schedule, status);
        },
        _refresh,
        duplicate: 'This student already has an enrollment record for this '
            'subject. Edit that record instead.',
      );

  Future<String?> remove(int id) => runAction(
        () => _repo.delete(id),
        _refresh,
        reference: 'Cannot delete: this enrollment already has a grade. '
            'Delete the grade first.',
      );
}
