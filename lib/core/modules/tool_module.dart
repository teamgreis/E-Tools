import 'package:flutter/material.dart';

/// A single tool module in the E-Tools registry.
///
/// Adding a new module to the app means creating a [ToolModule] and calling
/// [ModuleRegistry.register] — the dashboard, the menu panel and the dock
/// pick it up automatically without any UI changes.
@immutable
class ToolModule {
  const ToolModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.tags = const <String>[],
    this.pageBuilder,
  });

  /// Stable identifier, also used as the route: `/module/<id>`.
  final String id;

  final String title;
  final String description;
  final IconData icon;

  /// Groups the module in the menu panel, e.g. `Network`.
  final String category;

  /// Additional search keywords.
  final List<String> tags;

  /// Optional page builder. When omitted the module renders a
  /// "not implemented yet" stub, which is the honest default.
  final WidgetBuilder? pageBuilder;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }
}
