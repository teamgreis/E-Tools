import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';
import '../components/bottom_dock.dart';
import '../components/module_menu_panel.dart';
import 'app_background.dart';

/// The persistent app frame: background, routed content and the floating
/// bottom dock with the expandable module menu above it.
///
/// The shell wraps every route (see `MaterialApp.router`'s builder), so the
/// dock and its menu survive navigation between modules.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _menuOpen = false;

  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
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
            duration: DesignTokens.motionBase,
            curve: DesignTokens.curve,
            scale: _menuOpen ? 1 : 0.96,
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
            onToggleMenu: () => setState(() => _menuOpen = !_menuOpen),
            onAddFavorite: () => setState(() => _menuOpen = true),
          ),
        ),
      ],
    );
  }
}
