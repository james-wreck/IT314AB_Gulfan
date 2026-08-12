import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/download.jpg",
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "James Laurence C. Gulfan",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("BSIT - 3", style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        const Divider(),
                        const Text(
                          "My First Flutter Application",
                          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.amber,
                          size: 40,
                        ),
                        Row(
                          children: [
                            Text("AGE: 19"),
                            Text("Birthday: August 20, 2006"),
                          ],
                        ),
                        const Text(
                          "Hobby : Guitar",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("August 11, 2026", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),


                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "My Favorites",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Favorite Game: Mobile Legends",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Favorite Food: Buwad",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Favorite Movie: The Bible",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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