import 'package:flutter/material.dart';
import 'package:identity/identity.dart';

class SnackBarNotifier extends Notifier {
  @override
  void notify(BuildContext context, String message, [Map parameters]) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
