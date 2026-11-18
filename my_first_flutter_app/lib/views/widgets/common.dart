import 'package:flutter/material.dart';

/// Shows a spinner, an error with Retry, an empty message, or the child.
class AsyncBody extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final String emptyText;
  final VoidCallback onRetry;
  final Widget child;

  const AsyncBody({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.isEmpty,
    required this.emptyText,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (isEmpty) return Center(child: Text(emptyText));
    return child;
  }
}

Future<bool> confirmDelete(BuildContext context, String what) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete?'),
      content: Text('Delete $what?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return ok == true;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
