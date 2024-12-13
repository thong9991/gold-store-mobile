import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage pageTransition(
    {required Widget page,
    required Widget Function(
            BuildContext, Animation<double>, Animation<double>, Widget)
        transitionsBuilder,
    Duration duration = const Duration(
      milliseconds: 300,
    )}) {
  return CustomTransitionPage(
      child: page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: transitionsBuilder);
}
