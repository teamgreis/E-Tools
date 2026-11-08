import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/motion/haptics.dart';
import '../../core/motion/springs.dart';
import '../../core/settings/app_settings.dart';
import '../../core/theme/design_tokens.dart';
import '../../app/router.dart' show appRouterProvider;
import '../components/bottom_dock.dart';
import '../components/module_menu_panel.dart';
import 'app_background.dart';

/// The persistent app frame: background, routed content and the floating
/// bottom dock with the expandable module menu above it.
///
/// The shell wraps every route (a go_router `ShellRoute`), so the dock and
/// its menu survive navigation between modules. Menu open/close is
/// spring-animated and haptically acknowledged.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _menuOpen = false;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = ref.read(appRouterProvider);
    // iOS-like behaviour: any navigation closes the menu sheet.
    _router.routeInformationProvider.addListener(_closeMenu);
  }

  @override
  void dispose() {
    _router.routeInformationProvider.removeListener(_closeMenu);
    super.dispose();
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    AppHaptics.stateChange(ref);
  }

  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);

    return Stack(
      children: [
        const Positioned.fill(child: AppBackground()),
        Positioned.fill(child: widget.child),
        if (_menuOpen)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
        Positioned(
          left: 12,
          right: 12,
          bottom: DesignTokens.dockHeight + 24,
          child: AnimatedScale(
            duration: Springs.durationFor(settings),
            curve: Springs.curveFor(settings),
            scale: _menuOpen ? 1 : 0.9,
            alignment: Alignment.bottomCenter,
            child:
                _menuOpen ? const ModuleMenuPanel() : const SizedBox.shrink(),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: BottomDock(
            menuOpen: _menuOpen,
            onToggleMenu: _toggleMenu,
            onAddFavorite: () {
              if (!_menuOpen) _toggleMenu();
            },
          ),
        ),
      ],
    );
  }
}
