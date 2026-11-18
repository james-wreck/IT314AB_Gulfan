class Program {
  final int programId;
  final String programName;

  Program({required this.programId, required this.programName});

  factory Program.fromRow(Map<String, dynamic> row) {
    return Program(
      programId: row['program_id'] as int,
      programName: row['program_name'] as String,
    );
  }
}
