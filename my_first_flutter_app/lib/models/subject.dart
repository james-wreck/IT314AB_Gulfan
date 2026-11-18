class Subject {
  final int? subjectId;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String? description;

  Subject({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    this.description,
  });

  factory Subject.fromRow(Map<String, dynamic> row) {
    return Subject(
      subjectId: row['subject_id'] as int,
      subjectCode: row['subject_code'] as String,
      subjectName: row['subject_name'] as String,
      units: row['units'] as int,
      description: row['description'] as String?,
    );
  }
}
