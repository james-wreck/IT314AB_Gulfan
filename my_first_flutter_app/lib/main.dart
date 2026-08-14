import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List<Map<String, dynamic>> profiles = [
  {
    'image': 'assets/da.jfif',
    'name': "James Laurence C. Gulfan",
    'courseSection': "BSIT - 3",
    'age': 19,
    'hobby': "Basketball",
  },
  {
    'image': 'assets/john.jfif',
    'name': "John Deacon",
    'courseSection': "BSIT - 3",
    'age': 23,
    'hobby': null,
  },
  {
    'image': 'assets/brian.jfif',
    'name': "Brian May",
    'courseSection': "BSIT - 3",
    'age': null,
    'hobby': "Sleeping",
  },
  {
    'image': 'assets/fred.jfif',
    'name': "Fred Merc",
    'courseSection': "BSIT - 3",
    'age': 20,
    'hobby': "Singing",
  },
  {
    'image': 'assets/roger.jfif',
    'name': "Roger Taylor",
    'courseSection': null,
    'age': 26,
    'hobby': "Dancing",
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Text("My First Flutter Application"),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                ...profiles.map(
                  (profile) => Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            profile['courseSection'] ?? "Course: Empty",
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
                            "Hobby : ${profile['hobby'] ?? "Empty"}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}