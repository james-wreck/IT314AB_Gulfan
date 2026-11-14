import 'package:flutter/material.dart';
import 'edit_student_dialog.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const StudentDetailsScreen({
    super.key,
    required this.profile,
  });

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  Map<String, dynamic> get profile => widget.profile;

  Widget _buildImage(dynamic path) {
    const fallback = Icon(Icons.account_circle, size: 100);

    if (path == null) return fallback;

    return Image.asset(
      path.toString(),
      width: 100,
      height: 100,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.teal,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              _buildImage(profile['image']),

              const SizedBox(height: 15),

              Text(
                profile['name'] ?? "Name: Empty",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Student ID: ${profile['studentID'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Course: ${profile['courseSection'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Age: ${profile['age'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Hobby: ${profile['hobby'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Email: ${profile['email'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Favorite Subject: ${profile['favSubject'] ?? "Empty"}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                profile['active'] ? "Active" : "Inactive",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: profile['active'] ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () async {
                  final saved =
                      await showEditStudentDialog(context, profile);

                  if (saved && mounted) {
                    setState(() {});
                  }
                },
                child: const Text("Edit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}