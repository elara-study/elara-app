import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Central navigation helpers for [GoRouter]-backed routes.
abstract final class AppNavigation {
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String location, {
    Object? arguments,
  }) {
    return GoRouter.of(context).push<T>(location, extra: arguments);
  }

  static void pushReplacementNamed(
    BuildContext context,
    String location, {
    Object? arguments,
  }) {
    GoRouter.of(context).pushReplacement(location, extra: arguments);
  }

  static void goNamed(BuildContext context, String location, {Object? extra}) {
    GoRouter.of(context).go(location, extra: extra);
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String location) {
    GoRouter.of(context).go(location);
  }
}
