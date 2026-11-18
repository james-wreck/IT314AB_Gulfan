import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule.dart';
import '../viewmodels/schedule_viewmodel.dart';
import 'widgets/common.dart';

const List<String> _days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ScheduleViewModel>().load();
    });
  }

  void _openForm([Schedule? schedule]) {
    showDialog(
      context: context,
      builder: (_) => _ScheduleForm(schedule: schedule),
    );
  }

  Future<void> _delete(Schedule s) async {
    if (!await confirmDelete(context, '${s.subjectCode} ${s.dayOfWeek}')) {
      return;
    }
    if (!mounted) return;
    final error =
        await context.read<ScheduleViewModel>().remove(s.scheduleId!);
    if (error != null && mounted) showMessage(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    return Scaffold(
      appBar:
          AppBar(title: const Text('Schedules'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(
        isLoading: vm.isLoading,
        errorMessage: vm.errorMessage,
        isEmpty: vm.schedules.isEmpty,
        emptyText: 'No schedules found',
        onRetry: vm.load,
        child: ListView.builder(
          itemCount: vm.schedules.length,
          itemBuilder: (context, i) {
            final s = vm.schedules[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                isThreeLine: true,
                title: Text('${s.subjectCode} - ${s.subjectName}'),
                subtitle: Text(
                  '${s.dayOfWeek} ${s.startTime}-${s.endTime} | Room ${s.room}\n'
                  'Slots: ${s.enrolledCount}/${s.slotCapacity}',
                ),
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

class _ScheduleForm extends StatefulWidget {
  final Schedule? schedule;
  const _ScheduleForm({this.schedule});

  @override
  State<_ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<_ScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _start;
  late final TextEditingController _end;
  late final TextEditingController _room;
  late final TextEditingController _capacity;
  int? _subjectId;
  String? _day;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _start = TextEditingController(text: s?.startTime ?? '');
    _end = TextEditingController(text: s?.endTime ?? '');
    _room = TextEditingController(text: s?.room ?? '');
    _capacity = TextEditingController(text: s?.slotCapacity.toString() ?? '');
    _subjectId = s?.subjectId;
    _day = s?.dayOfWeek;
  }

  @override
  void dispose() {
    _start.dispose();
    _end.dispose();
    _room.dispose();
    _capacity.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController c) async {
    final parts = c.text.split(':');
    final initial = parts.length == 2
        ? TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 8,
            minute: int.tryParse(parts[1]) ?? 0,
          )
        : const TimeOfDay(hour: 8, minute: 0);
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t != null) {
      c.text = '${t.hour.toString().padLeft(2, '0')}:'
          '${t.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final vm = context.read<ScheduleViewModel>();
    final schedule = Schedule(
      scheduleId: widget.schedule?.scheduleId,
      subjectId: _subjectId!,
      dayOfWeek: _day!,
      startTime: _start.text,
      endTime: _end.text,
      room: _room.text.trim(),
      slotCapacity: int.parse(_capacity.text.trim()),
    );

    final error =
        _isEdit ? await vm.update(schedule) : await vm.add(schedule);
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
    final subjects = context.watch<ScheduleViewModel>().subjects;

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Schedule' : 'Add Schedule'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: _subjectId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Subject'),
                  items: subjects
                      .map((s) => DropdownMenuItem(
                            value: s.subjectId!,
                            child: Text('${s.subjectCode} - ${s.subjectName}',
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _subjectId = v),
                  validator: (v) => v == null ? 'Select a subject' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _day,
                  decoration: const InputDecoration(labelText: 'Day'),
                  items: _days
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setState(() => _day = v),
                  validator: (v) => v == null ? 'Select a day' : null,
                ),
                TextFormField(
                  controller: _start,
                  readOnly: true,
                  onTap: () => _pickTime(_start),
                  decoration: const InputDecoration(
                    labelText: 'Start time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Pick a start time' : null,
                ),
                TextFormField(
                  controller: _end,
                  readOnly: true,
                  onTap: () => _pickTime(_end),
                  decoration: const InputDecoration(
                    labelText: 'End time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Pick an end time';
                    // 'HH:MM' strings compare correctly as text
                    if (_start.text.isNotEmpty && v.compareTo(_start.text) <= 0) {
                      return 'End time must be after start time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _room,
                  decoration: const InputDecoration(labelText: 'Room'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: _capacity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Slot capacity'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n <= 0) return 'Enter a whole number > 0';
                    return null;
                  },
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
