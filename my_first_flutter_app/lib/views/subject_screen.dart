import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'widgets/common.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SubjectViewModel>().load();
    });
  }

  void _openForm([Subject? subject]) {
    showDialog(
      context: context,
      builder: (_) => _SubjectForm(subject: subject),
    );
  }

  Future<void> _delete(Subject s) async {
    if (!await confirmDelete(context, s.subjectName)) return;
    if (!mounted) return;
    final error = await context.read<SubjectViewModel>().remove(s.subjectId!);
    if (error != null && mounted) showMessage(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SubjectViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Subjects'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        isLoading: vm.isLoading,
        errorMessage: vm.errorMessage,
        isEmpty: vm.subjects.isEmpty,
        emptyText: 'No subjects found',
        onRetry: vm.load,
        child: ListView.builder(
          itemCount: vm.subjects.length,
          itemBuilder: (context, i) {
            final s = vm.subjects[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text('${s.subjectCode} - ${s.subjectName}'),
                subtitle: Text(
                  '${s.units} unit(s)'
                  '${s.description == null ? '' : '\n${s.description}'}',
                ),
                isThreeLine: s.description != null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(s),
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

class _SubjectForm extends StatefulWidget {
  final Subject? subject;
  const _SubjectForm({this.subject});

  @override
  State<_SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<_SubjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _units;
  late final TextEditingController _desc;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.subject != null;

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _code = TextEditingController(text: s?.subjectCode ?? '');
    _name = TextEditingController(text: s?.subjectName ?? '');
    _units = TextEditingController(text: s?.units.toString() ?? '');
    _desc = TextEditingController(text: s?.description ?? '');
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _units.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final vm = context.read<SubjectViewModel>();
    final desc = _desc.text.trim();
    final subject = Subject(
      subjectId: widget.subject?.subjectId,
      subjectCode: _code.text.trim(),
      subjectName: _name.text.trim(),
      units: int.parse(_units.text.trim()),
      description: desc.isEmpty ? null : desc,
    );

    final error = _isEdit ? await vm.update(subject) : await vm.add(subject);
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

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Subject' : 'Add Subject'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _code,
                  decoration: const InputDecoration(labelText: 'Subject code'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Subject name'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _units,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Units'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n <= 0) return 'Enter a whole number > 0';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _desc,
                  decoration:
                      const InputDecoration(labelText: 'Description (optional)'),
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
