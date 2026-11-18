import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';

/// Used for both Add (student == null) and Edit (student != null).
class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  int? _programId;
  bool _saving = false;

  bool get _isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
      text: widget.student?.studentId?.toString() ?? '',
    );
    _nameController =
        TextEditingController(text: widget.student?.studentName ?? '');
    _programId = widget.student?.programId;
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final vm = context.read<StudentViewModel>();
    final student = Student(
      studentId: int.parse(_idController.text.trim()),
      studentName: _nameController.text.trim(),
      programId: _programId,
    );

    final error =
        _isEdit ? await vm.updateStudent(student) : await vm.addStudent(student);

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final programs = context.watch<StudentViewModel>().programs;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Student' : 'Add Student'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                readOnly: _isEdit, // the primary key is not editable
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Student ID is required';
                  if (int.tryParse(value) == null) return 'Numbers only';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Student name'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _programId,
                decoration: const InputDecoration(labelText: 'Program'),
                items: programs
                    .map((p) => DropdownMenuItem(
                          value: p.programId,
                          child: Text(p.programName),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _programId = v),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
