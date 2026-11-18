import '../core/base_viewmodel.dart';
import '../models/program.dart';
import '../models/student.dart';
import '../repositories/program_repository.dart';
import '../repositories/student_repository.dart';

class StudentViewModel extends BaseViewModel {
  final StudentRepository _students;
  final ProgramRepository _programs;
  StudentViewModel(this._students, this._programs);

  List<Student> students = [];
  List<Program> programs = [];

  Future<void> _refresh() async {
    students = await _students.getAll();
  }

  Future<void> load() => runLoad(() async {
        await _refresh();
        programs = await _programs.getAll();
      });

  Future<String?> addStudent(Student student) => runAction(
        () => _students.insert(student),
        _refresh,
        duplicate: 'Student ID ${student.studentId} already exists.',
        reference: 'The selected program does not exist.',
      );

  Future<String?> updateStudent(Student student) => runAction(
        () => _students.update(student),
        _refresh,
        reference: 'The selected program does not exist.',
      );

  Future<String?> removeStudent(int id) => runAction(
        () => _students.delete(id),
        _refresh,
        reference: 'Cannot delete: this student has enrollments.',
      );
}
