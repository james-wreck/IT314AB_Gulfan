import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/enrollment.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import 'widgets/common.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<EnrollmentViewModel>().load();
    });
  }

  void _openForm([Enrollment? enrollment]) {
    showDialog(
      context: context,
      builder: (_) => _EnrollmentForm(enrollment: enrollment),
    );
  }

  Future<void> _delete(Enrollment e) async {
    if (!await confirmDelete(context, e.label)) return;
    if (!mounted) return;
    final error =
        await context.read<EnrollmentViewModel>().remove(e.enrollmentId!);
    if (error != null && mounted) showMessage(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnrollmentViewModel>();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Enrollments'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        isLoading: vm.isLoading,
        errorMessage: vm.errorMessage,
        isEmpty: vm.enrollments.isEmpty,
        emptyText: 'No enrollments found',
        onRetry: vm.load,
        child: ListView.builder(
          itemCount: vm.enrollments.length,
          itemBuilder: (context, i) {
            final e = vm.enrollments[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                isThreeLine: true,
                title: Text(e.label),
                subtitle: Text(
                  '${e.subjectName}\n'
                  '${e.dayOfWeek} ${e.startTime}-${e.endTime} | '
                  'Room ${e.room} | ${e.status}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(e),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(e),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Add: pick a student and a schedule (the schedule decides the subject).
/// Edit: the student is fixed; the schedule and the status can change.
class _EnrollmentForm extends StatefulWidget {
  final Enrollment? enrollment;
  const _EnrollmentForm({this.enrollment});

  @override
  State<_EnrollmentForm> createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<_EnrollmentForm> {
  final _formKey = GlobalKey<FormState>();
  int? _studentId;
  int? _scheduleId;
  String _status = 'Enrolled';
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.enrollment != null;

  @override
  void initState() {
    super.initState();
    _studentId = widget.enrollment?.studentId;
    _scheduleId = widget.enrollment?.scheduleId;
    _status = widget.enrollment?.status ?? 'Enrolled';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final vm = context.read<EnrollmentViewModel>();
    final schedule =
        vm.schedules.firstWhere((s) => s.scheduleId == _scheduleId);

    final error = _isEdit
        ? await vm.update(widget.enrollment!.enrollmentId!,
            widget.enrollment!.studentId, schedule, _status)
        : await vm.add(_studentId!, schedule);
    if (!mounted) return;

    if (error != null) {
      setState(() {
        _saving = false;
        _error = error;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EnrollmentViewModel>();

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Enrollment' : 'Add Enrollment'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: _studentId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Student'),
                  items: vm.students
                      .map((s) => DropdownMenuItem(
                            value: s.studentId!,
                            child: Text('${s.studentId} - ${s.studentName}',
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged:
                      _isEdit ? null : (v) => setState(() => _studentId = v),
                  validator: (v) => v == null ? 'Select a student' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _scheduleId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Schedule'),
                  items: vm.schedules
                      .map((s) => DropdownMenuItem(
                            value: s.scheduleId!,
                            child: Text(s.label,
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _scheduleId = v),
                  validator: (v) => v == null ? 'Select a schedule' : null,
                ),
                if (_isEdit) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const ['Enrolled', 'Dropped']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _status = v!),
                  ),
                ],
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
