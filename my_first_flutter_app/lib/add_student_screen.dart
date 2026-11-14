import 'package:flutter/material.dart';
import 'student_data.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _course = TextEditingController();
  final _age = TextEditingController();
  final _hobby = TextEditingController();
  final _studentId = TextEditingController();
  final _email = TextEditingController();
  final _favSubject = TextEditingController();
  bool _active = true;

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

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    if (!isValidEmail(v)) return 'Enter a valid email address';
    return null;
  }

  String? _validateAge(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final age = int.tryParse(v.trim());
    if (age == null || age < 1 || age > 120) return 'Enter a valid age';
    return null;
  }

  String? _validateStudentId(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (isStudentIdTaken(v)) return 'Student ID already exists';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await addStudent({
      'image': null,
      'name': _name.text.trim(),
      'courseSection': _nullIfEmpty(_course.text),
      'age': int.tryParse(_age.text.trim()),
      'hobby': _nullIfEmpty(_hobby.text),
      'studentID': _studentId.text.trim(),
      'email': _nullIfEmpty(_email.text),
      'favSubject': _nullIfEmpty(_favSubject.text),
      'pressed': false,
      'favorite': false,
      'active': _active,
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
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
                validator: _validateAge,
              ),
              TextFormField(
                controller: _hobby,
                decoration: const InputDecoration(labelText: 'Hobby'),
              ),
              TextFormField(
                controller: _studentId,
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: _validateStudentId,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Enroll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}