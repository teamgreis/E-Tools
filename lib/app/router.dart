import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/layout/app_shell.dart';
import '../ui/pages/dashboard_page.dart';
import '../ui/pages/module_page.dart';

/// App router: dashboard plus one dynamic route per module, wrapped in the
/// shell route so the dock and its menu persist across navigation.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _fadePage(
              child: const DashboardPage(),
              key: const ValueKey('dashboard'),
            ),
          ),
          GoRoute(
            path: '/module/:id',
            pageBuilder: (context, state) => _fadePage(
              child: ModulePage(moduleId: state.pathParameters['id']!),
              key: ValueKey('module_${state.pathParameters['id']}'),
            ),
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: child,
      );
    },
  );
}
