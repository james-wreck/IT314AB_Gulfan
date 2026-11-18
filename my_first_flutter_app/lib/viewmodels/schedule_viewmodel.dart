import '../core/base_viewmodel.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/subject_repository.dart';

class ScheduleViewModel extends BaseViewModel {
  final ScheduleRepository _repo;
  final SubjectRepository _subjects;
  ScheduleViewModel(this._repo, this._subjects);

  List<Schedule> schedules = [];
  List<Subject> subjects = []; // for the subject dropdown

  Future<void> _refresh() async {
    schedules = await _repo.getAll();
  }

  Future<void> load() => runLoad(() async {
        await _refresh();
        subjects = await _subjects.getAll();
      });

  Future<String?> add(Schedule s) =>
      runAction(() => _repo.insert(s), _refresh);

  Future<String?> update(Schedule s) =>
      runAction(() => _repo.update(s), _refresh);

  Future<String?> remove(int id) => runAction(
        () => _repo.delete(id),
        _refresh,
        reference: 'Cannot delete: students are enrolled in this schedule.',
      );
}
