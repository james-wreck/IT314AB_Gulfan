import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const StudentDetailsScreen({
    super.key,
    required this.profile,
  });

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
              Image.asset(
                profile['image'],
                width: 100,
                height: 100,
              ),

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

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Course: ${profile['courseSection'] ?? "Empty"}",

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Age: ${profile['age'] ?? "Empty"}",

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Hobby: ${profile['hobby'] ?? "Empty"}",

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Email: ${profile['email'] ?? "Empty"}",

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Favorite Subject: "
                    "${profile['favSubject'] ?? "Empty"}",

                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                profile['active']
                    ? "Active"
                    : "Inactive",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: profile['active']
                      ? Colors.green
                      : Colors.red,
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Edit Student",
                        ),


                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Name: ${profile['name']}"),
                            Text("Student ID: ${profile['studentID']}"),
                            Text("Course: ${profile['courseSection']}"),
                            Text("Age: ${profile['age']}"),
                            Text("Hobby: ${profile['hobby']}"),
                            Text("Email: ${profile['email']}"),
                            Text("Favorite Subject: ${profile['favSubject']}"),
                          ],
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: const Text(
                              "Close",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                child: const Text(
                  "Edit",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}