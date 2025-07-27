import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignOutDialog extends StatelessWidget {
  final BuildContext parentContext;
  const SignOutDialog({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Wanna sign out ?')),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onError,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            _signOut();
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _signOut() async {
    Get.toNamed('/splash');

    await Future.delayed(const Duration(milliseconds: 1000));

    Get.offNamedUntil('/auth', (_) => false);
  }
}
