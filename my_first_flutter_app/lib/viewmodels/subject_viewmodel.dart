import '../core/base_viewmodel.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';

class SubjectViewModel extends BaseViewModel {
  final SubjectRepository _repo;
  SubjectViewModel(this._repo);

  List<Subject> subjects = [];

  Future<void> _refresh() async {
    subjects = await _repo.getAll();
  }

  Future<void> load() => runLoad(_refresh);

  Future<String?> add(Subject s) => runAction(
        () => _repo.insert(s),
        _refresh,
        duplicate: 'Subject code "${s.subjectCode}" already exists.',
      );

  Future<String?> update(Subject s) => runAction(
        () => _repo.update(s),
        _refresh,
        duplicate: 'Subject code "${s.subjectCode}" already exists.',
      );

  Future<String?> remove(int id) => runAction(
        () => _repo.delete(id),
        _refresh,
        reference: 'Cannot delete: this subject has schedules or enrollments.',
      );
}
