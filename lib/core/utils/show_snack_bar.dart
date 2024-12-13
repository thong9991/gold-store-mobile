import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'language_manager.dart';

void showSnackBar(BuildContext context, ToastificationType type, String message,
    bool isTranslated) {
  List<String> wordList = message.split(" ");
  String translateMessage =
      List.generate(wordList.length, (i) => wordList[i].tr(context)).join(" ");
  toastification.show(
    context: context,
    style: ToastificationStyle.flatColored,
    type: type,
    description: Text(
      isTranslated ? translateMessage : message,
      style: Theme.of(context).textTheme.titleSmall,
    ),
    autoCloseDuration: const Duration(seconds: 5),
  );
}
