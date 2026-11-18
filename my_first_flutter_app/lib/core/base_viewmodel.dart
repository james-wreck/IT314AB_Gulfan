import 'package:flutter/foundation.dart';
import 'db_error.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  /// Runs a load with the loading / error states handled.
  Future<void> runLoad(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      errorMessage = 'Connection failed: ${dbErrorMessage(e)}';
    }
    isLoading = false;
    notifyListeners();
  }

  /// Runs a write, then refreshes the list.
  /// Returns null on success, or an error message to show the user.
  Future<String?> runAction(
    Future<void> Function() write,
    Future<void> Function() refresh, {
    String? duplicate,
    String? reference,
  }) async {
    try {
      await write();
      await refresh();
      notifyListeners();
      return null;
    } catch (e) {
      return dbErrorMessage(e, duplicate: duplicate, reference: reference);
    }
  }
}
