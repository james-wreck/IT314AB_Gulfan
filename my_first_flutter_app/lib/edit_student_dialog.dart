import 'package:flutter/material.dart';
import 'student_data.dart';

/// Shows the Edit modal. Returns true if the student was saved.
Future<bool> showEditStudentDialog(
  BuildContext context,
  Map<String, dynamic> profile,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _EditStudentDialog(profile: profile),
  );
  return result ?? false;
}

class _EditStudentDialog extends StatefulWidget {
  final Map<String, dynamic> profile;

  const _EditStudentDialog({required this.profile});

  @override
  State<_EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<_EditStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _course;
  late final TextEditingController _age;
  late final TextEditingController _hobby;
  late final TextEditingController _studentId;
  late final TextEditingController _email;
  late final TextEditingController _favSubject;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _name = TextEditingController(text: p['name']?.toString() ?? '');
    _course = TextEditingController(text: p['courseSection']?.toString() ?? '');
    _age = TextEditingController(text: p['age']?.toString() ?? '');
    _hobby = TextEditingController(text: p['hobby']?.toString() ?? '');
    _studentId = TextEditingController(text: p['studentID']?.toString() ?? '');
    _email = TextEditingController(text: p['email']?.toString() ?? '');
    _favSubject = TextEditingController(text: p['favSubject']?.toString() ?? '');
    _active = p['active'] == true;
  }

  @override
  void dispose() {
    _name.dispose();
    _course.dispose();
    _age.dispose();
    _hobby.dispose();
    _studentId.dispose();
    _email.dispose();
    _favSubject.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String s) {
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _idValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (isStudentIdTaken(v, except: widget.profile)) {
      return 'Student ID already exists';
    }
    return null;
  }

  String? _emailValidator(String? v) =>
      isValidEmail(v) ? null : 'Enter a valid email address';

  String? _ageValidator(String? v) =>
      isValidAge(v) ? null : 'Enter a valid age';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Update the SAME map so the list and details stay consistent.
    final p = widget.profile;
    p['name'] = _name.text.trim();
    p['courseSection'] = _nullIfEmpty(_course.text);
    p['age'] = int.tryParse(_age.text.trim());
    p['hobby'] = _nullIfEmpty(_hobby.text);
    p['studentID'] = _studentId.text.trim();
    p['email'] = _nullIfEmpty(_email.text);
    p['favSubject'] = _nullIfEmpty(_favSubject.text);
    p['active'] = _active;

    await updateStudent(); // re-sort and save locally

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Student"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _required,
              ),
              TextFormField(
                controller: _course,
                decoration:
                    const InputDecoration(labelText: 'Course / Section'),
              ),
              TextFormField(
                controller: _age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: _ageValidator,
              ),
              TextFormField(
                controller: _hobby,
                decoration: const InputDecoration(labelText: 'Hobby'),
              ),
              TextFormField(
                controller: _studentId,
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: _idValidator,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              TextFormField(
                controller: _favSubject,
                decoration:
                    const InputDecoration(labelText: 'Favorite Subject'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}