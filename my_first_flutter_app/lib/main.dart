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
    'pressed': false,
    'favorite': false,
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
    'pressed': false,
    'favorite': false,
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
    'pressed': false,
    'favorite': false,
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
    'pressed': false,
    'favorite': false,
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
    'pressed': false,
    'favorite': false,
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
    'pressed': false,
    'favorite': false,
  },
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

                return GestureDetector(
                  onTap: () {
                    print(
                      "Student Card Tapped: ${profile['name']}",
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          // IMAGE
                          Image.asset(
                            profile['image'],
                            width: 100,
                            height: 100,
                          ),

                          const SizedBox(height: 15),

                          // NAME
                          Text(
                            profile['name'] ?? "Name: Empty",
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // COURSE AND SECTION
                          Text(
                            profile['courseSection']
                                ?? "Course: Empty",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // AGE
                          Text(
                            "AGE: ${profile['age'] ?? "Empty"}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // HOBBY
                          Text(
                            "Hobby : ${profile['hobby'] ?? "Empty"}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // STUDENT ID
                          Text(
                            "studentID : "
                            "${profile['studentID'] ?? "Empty"}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // EMAIL
                          Text(
                            "email : "
                            "${profile['email'] ?? "Empty"}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // FAVORITE SUBJECT
                          Text(
                            "Favorite Subject : "
                            "${profile['favSubject'] ?? "Empty"}",

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // FLAG 3
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

                          // FLAG 4 - FAVORITE
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
      ),
    );
  }
}