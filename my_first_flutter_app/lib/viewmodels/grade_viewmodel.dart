import '../core/base_viewmodel.dart';
import '../models/enrollment.dart';
import '../models/grade.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/grade_repository.dart';

class GradeViewModel extends BaseViewModel {
  final GradeRepository _repo;
  final EnrollmentRepository _enrollments;
  GradeViewModel(this._repo, this._enrollments);

  List<Grade> grades = [];
  List<Enrollment> enrollments = [];

  /// Only 'Enrolled' enrollments that do not have a grade yet.
  List<Enrollment> get ungraded {
    final done = grades.map((g) => g.enrollmentId).toSet();
    return enrollments
        .where((e) => e.status == 'Enrolled' && !done.contains(e.enrollmentId))
        .toList();
  }

  Future<void> _refresh() async {
    grades = await _repo.getAll();
    enrollments = await _enrollments.getAll();
  }

  Future<void> load() => runLoad(_refresh);

  Future<String?> add(Grade g) => runAction(
        () => _repo.insert(g),
        _refresh,
        duplicate: 'This enrollment already has a grade.',
        reference: 'That enrollment does not exist.',
      );

  Future<String?> update(Grade g) =>
      runAction(() => _repo.update(g), _refresh);

  Future<String?> remove(int id) => runAction(() => _repo.delete(id), _refresh);
}
