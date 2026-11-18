import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grade.dart';
import '../viewmodels/grade_viewmodel.dart';
import 'widgets/common.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GradeViewModel>().load();
    });
  }

  void _openForm([Grade? grade]) {
    final vm = context.read<GradeViewModel>();
    if (grade == null && vm.ungraded.isEmpty) {
      showMessage(
          context, 'No enrollments without a grade. Enroll a student first.');
      return;
    }
    showDialog(context: context, builder: (_) => _GradeForm(grade: grade));
  }

  Future<void> _delete(Grade g) async {
    if (!await confirmDelete(context, 'the grade of ${g.studentName}')) return;
    if (!mounted) return;
    final error = await context.read<GradeViewModel>().remove(g.gradeId!);
    if (error != null && mounted) showMessage(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GradeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Grades'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        isLoading: vm.isLoading,
        errorMessage: vm.errorMessage,
        isEmpty: vm.grades.isEmpty,
        emptyText: 'No grades recorded',
        onRetry: vm.load,
        child: ListView.builder(
          itemCount: vm.grades.length,
          itemBuilder: (context, i) {
            final g = vm.grades[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                isThreeLine: true,
                title: Text('${g.studentName} - ${g.subjectCode}'),
                subtitle: Text(
                  'Grade: ${g.gradeValue.toStringAsFixed(2)}'
                  '${g.remarks == null ? '' : ' | ${g.remarks}'}\n'
                  'Recorded: ${g.dateRecorded ?? '-'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(g),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(g),
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

class _GradeForm extends StatefulWidget {
  final Grade? grade;
  const _GradeForm({this.grade});

  @override
  State<_GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends State<_GradeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _value;
  late final TextEditingController _remarks;
  int? _enrollmentId;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.grade != null;

  @override
  void initState() {
    super.initState();
    final g = widget.grade;
    _value = TextEditingController(text: g?.gradeValue.toString() ?? '');
    _remarks = TextEditingController(text: g?.remarks ?? '');
    _enrollmentId = g?.enrollmentId;
  }

  @override
  void dispose() {
    _value.dispose();
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final vm = context.read<GradeViewModel>();
    final remarks = _remarks.text.trim();
    final grade = Grade(
      gradeId: widget.grade?.gradeId,
      enrollmentId: _enrollmentId!,
      gradeValue: double.parse(_value.text.trim()),
      remarks: remarks.isEmpty ? null : remarks,
    );

    final error = _isEdit ? await vm.update(grade) : await vm.add(grade);
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
    final vm = context.watch<GradeViewModel>();
    // Edit: show every enrollment (the dropdown is disabled anyway).
    // Add: only enrollments that still have no grade.
    final options = _isEdit ? vm.enrollments : vm.ungraded;

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Grade' : 'Add Grade'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: _enrollmentId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Enrollment'),
                  items: options
                      .map((e) => DropdownMenuItem(
                            value: e.enrollmentId!,
                            child:
                                Text(e.label, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged:
                      _isEdit ? null : (v) => setState(() => _enrollmentId = v),
                  validator: (v) => v == null ? 'Select an enrollment' : null,
                ),
                TextFormField(
                  controller: _value,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Grade value'),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').trim());
                    if (n == null) return 'Enter a number';
                    // chk_grade_value: 0 to 100
                    if (n < 0 || n > 100) {
                      return 'Grade must be between 0 and 100';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _remarks,
                  decoration:
                      const InputDecoration(labelText: 'Remarks (optional)'),
                ),
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
