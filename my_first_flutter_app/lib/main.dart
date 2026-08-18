import 'package:flutter/material.dart';

void main() {
  profiles.sort((a, b) => a['name'].compareTo(b['name']));
  runApp(const MyApp());
}

List<Map<String, dynamic>> profiles = [
  {
    'image': 'assets/da.jfif',
    'name': "James Laurence C. Gulfan",
    'courseSection': "BSIT - 3",
    'age': 19,
    'hobby': "Basketball",
    'studentID': "24060149",
    'email': "james@gmail.com",
    'favSubject': "Programming",
  },
  {
    'image': 'assets/john.jfif',
    'name': "John Deacon",
    'courseSection': "BSIT - 3",
    'age': 23,
    'hobby': null,
    'studentID': "4932-1224",
    'email': "john@gmail.com",
    'favSubject': "Database",
  },
  {
    'image': 'assets/brian.jfif',
    'name': "Brian May",
    'courseSection': "BSIT - 3",
    'age': null,
    'hobby': "Sleeping",
    'studentID': "3003-2044",
    'email': "brian@gmail.com",
    'favSubject': "Web Development",
  },
  {
    'image': 'assets/fred.jfif',
    'name': "Fred Merc",
    'courseSection': "BSIT - 3",
    'age': 20,
    'hobby': "Singing",
    'studentID': "1302-6953",
    'email': null,
    'favSubject': "Programming",
  },
  {
    'image': 'assets/roger.jfif',
    'name': "Roger Taylor",
    'courseSection': null,
    'age': 26,
    'hobby': "Dancing",
    'studentID': "2049-232",
    'email': "roger@gmail.com",
    'favSubject': "Networking",
  },
  {
    'image': 'assets/ds.webp',
    'name': "Tommy Shelby",
    'courseSection': "BSCS - 2",
    'age': 20,
    'hobby': "Basketball",
    'studentID': "2309-2060",
    'email': "tommy@gmail.com",
    'favSubject': "Cybersecurity",
  }
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
            child: ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];

                return Card(
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
                        Text(
                          "studentID : ${profile['studentID'] ?? "Empty"}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "email : ${profile['email'] ?? "Empty"}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Favorite Subject : ${profile['favSubject'] ?? "Empty"}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}