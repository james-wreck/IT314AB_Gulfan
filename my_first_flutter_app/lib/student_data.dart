import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> profiles = [
  {
    'image': 'assets/da.jfif',
    'name': 'James Laurence C. Gulfan',
    'courseSection': 'BSIT - 3',
    'age': 19,
    'hobby': 'Basketball',
    'studentID': '24060149',
    'email': 'james@gmail.com',
    'favSubject': 'Programming',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/john.jfif',
    'name': 'John Deacon',
    'courseSection': 'BSIT - 3',
    'age': 23,
    'hobby': null,
    'studentID': '4932-1224',
    'email': 'john@gmail.com',
    'favSubject': 'Database',
    'pressed': false,
    'favorite': false,
    'active': false,
  },
  {
    'image': 'assets/brian.jfif',
    'name': 'Brian May',
    'courseSection': 'BSIT - 3',
    'age': null,
    'hobby': 'Sleeping',
    'studentID': '3003-2044',
    'email': 'brian@gmail.com',
    'favSubject': 'Web Development',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/fred.jfif',
    'name': 'Fred Merc',
    'courseSection': 'BSIT - 3',
    'age': 20,
    'hobby': 'Singing',
    'studentID': '1302-6953',
    'email': null,
    'favSubject': 'Programming',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
  {
    'image': 'assets/roger.jfif',
    'name': 'Roger Taylor',
    'courseSection': null,
    'age': 26,
    'hobby': 'Dancing',
    'studentID': '2049-232',
    'email': 'roger@gmail.com',
    'favSubject': 'Networking',
    'pressed': false,
    'favorite': false,
    'active': false,
  },
  {
    'image': 'assets/ds.webp',
    'name': 'Tommy Shelby',
    'courseSection': 'BSCS - 2',
    'age': 20,
    'hobby': 'Basketball',
    'studentID': '2309-2060',
    'email': 'tommy@gmail.com',
    'favSubject': 'Cybersecurity',
    'pressed': false,
    'favorite': false,
    'active': true,
  },
];

// New key (v2) so old data saved in a different format is ignored.
const String storageKey = 'saved_student_records_v2';

void sortProfiles() {
  profiles.sort(
    (a, b) => a['name'].toString().toLowerCase().compareTo(
          b['name'].toString().toLowerCase(),
        ),
  );
}

/// Loads saved records. If nothing is saved yet (first launch),
/// the default list above is kept and saved.
Future<void> loadProfiles() async {
  final prefs = await SharedPreferences.getInstance();
  final savedData = prefs.getString(storageKey);

  if (savedData != null && savedData.isNotEmpty) {
    try {
      final List<dynamic> decodedData = jsonDecode(savedData);
      profiles = decodedData
          .map((student) => Map<String, dynamic>.from(student))
          .toList();
    } catch (e) {
      // Corrupted data: fall back to the default list.
      sortProfiles();
      await saveProfiles();
    }
  } else {
    // No saved records yet.
    sortProfiles();
    await saveProfiles();
  }

  sortProfiles();
}

/// Saves the current list locally.
Future<void> saveProfiles() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(storageKey, jsonEncode(profiles));
}


/// Email is optional, but if filled in it must look like name@domain.com
bool isValidEmail(String? email) {
  final value = (email ?? '').trim();
  if (value.isEmpty) return true;
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
}

/// Age is optional, but if filled in it must be a number from 1 to 120.
bool isValidAge(String? age) {
  final value = (age ?? '').trim();
  if (value.isEmpty) return true;
  final n = int.tryParse(value);
  return n != null && n >= 1 && n <= 120;
}

/// True if another student already uses this ID.
/// Pass [except] when editing so a student doesn't clash with itself.
bool isStudentIdTaken(String id, {Map<String, dynamic>? except}) {
  final target = id.trim().toLowerCase();
  return profiles.any((p) =>
      !identical(p, except) &&
      p['studentID']?.toString().trim().toLowerCase() == target);
}

/// Adds a new student, keeps the list sorted, and saves locally.
Future<void> addStudent(Map<String, dynamic> student) async {
  profiles.add(student);
  sortProfiles();
  await saveProfiles();
}

/// Call after editing a student's map in place: re-sorts and saves.
Future<void> updateStudent() async {
  sortProfiles();
  await saveProfiles();
}