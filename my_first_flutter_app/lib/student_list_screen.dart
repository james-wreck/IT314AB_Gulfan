import 'package:flutter/material.dart';
import 'main.dart';
import 'student_details_screen.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,

      appBar: AppBar(
        title: const Text("My First Flutter Application"),
        backgroundColor: Colors.teal,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStudentScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: profiles.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people_outline,
                size: 80,
              ),

              const SizedBox(height: 20),

              const Text(
                "No students found",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
              : ListView.builder(
            itemCount: profiles.length,

            itemBuilder: (context, index) {
              final profile = profiles[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailsScreen(
                        profile: profile,
                      ),

                    ),
                  );
                },

                child: Card(
                  margin: const EdgeInsets.all(20),

                  color: profile['favorite']
                      ? Colors.amber[100]
                      : Colors.white,

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,

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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          profile['courseSection']
                              ?? "Course: Empty",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "AGE: ${profile['age'] ?? "Empty"}",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Hobby : "
                              "${profile['hobby'] ?? "Empty"}",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "studentID : "
                              "${profile['studentID'] ?? "Empty"}",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "email : "
                              "${profile['email'] ?? "Empty"}",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Favorite Subject : "
                              "${profile['favSubject'] ?? "Empty"}",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          profile['active']
                              ? "Active"
                              : "Inactive",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: profile['active']
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          profile['pressed']
                              ? "Button Pressed!"
                              : "Not Pressed",

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              profile['favorite'] =
                              !profile['favorite'];
                            });

                            print(
                              "Favorite changed for "
                                  "${profile['name']}",
                            );
                          },

                          icon: Icon(
                            profile['favorite']
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),

                          label: Text(
                            profile['favorite']
                                ? "Favorited"
                                : "Favorite",
                          ),
                        ),

                        const SizedBox(height: 5),

                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,

                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Edit Student",
                                  ),

                                  content: Text(
                                    "Ready to edit "
                                        "${profile['name']}",
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                        );
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

                        const SizedBox(height: 5),

                        if (profile['active'])
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                profiles.removeAt(index);
                              });

                              print(
                                "Deleted "
                                    "${profile['name']}",
                              );
                            },

                            child: const Text(
                              "Delete",
                            ),
                          ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}