import 'package:postgres/postgres.dart';

/// Thrown by our own business-rule checks (duplicate, conflict, no slots).
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

/// Turns any error into a short message the user can read.
String dbErrorMessage(Object e, {String? duplicate, String? reference}) {
  if (e is ValidationException) return e.message;
  if (e is ServerException) {
    switch (e.code) {
      case '23505': // unique violation
        return duplicate ?? 'This record already exists.';
      case '23503': // foreign key violation
        return reference ?? 'This record is linked to other records.';
      case '23514': // check constraint
        return 'The value was rejected by a database rule (CHECK constraint).';
      case '23502': // not null
        return 'A required value is missing.';
    }
    return e.message;
  }
  return e.toString();
}
