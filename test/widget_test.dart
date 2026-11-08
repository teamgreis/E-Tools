import 'package:e_tools/app/app.dart';
import 'package:e_tools/core/modules/module_registry.dart';
import 'package:e_tools/ui/components/module_menu_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    // The registry is normally populated in `main`; the test populates the
    // built-in catalogue itself.
    ModuleRegistry.registerDefaults();
  });

  testWidgets('dashboard lists the registered modules', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    expect(find.text('E-Tools'), findsOneWidget);
    expect(find.text('Network & Connectivity'), findsOneWidget);

    // The dashboard grid is scrollable: modules below the fold only exist
    // after scrolling to them.
    await tester.scrollUntilVisible(
      find.text('Diagnostics & Troubleshooting'),
      300,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();

    expect(find.text('Diagnostics & Troubleshooting'), findsOneWidget);
  });

  testWidgets('dock menu opens above the dock and lists every module',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    expect(find.text('Search modules'), findsNothing);

    await tester.tap(find.byTooltip('All modules'));
    await tester.pumpAndSettle();

    expect(find.text('Search modules'), findsOneWidget);

    // The menu panel scrolls; the last module only exists after scrolling.
    await tester.scrollUntilVisible(
      find.text('Hardware Center'),
      200,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();

    expect(find.text('Hardware Center'), findsOneWidget);
  });

  testWidgets('opening a module navigates to the module page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    await tester.tap(find.text('Network & Connectivity'));
    await tester.pumpAndSettle();

    expect(find.text('Network & Connectivity'), findsNWidgets(2));
    expect(find.text('Subnet calculator'), findsOneWidget);

    // The tool list is lazy: scroll the later sections into view.
    await tester.scrollUntilVisible(
      find.text('Reachability probe (TCP)'),
      200,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();
    expect(find.text('Reachability probe (TCP)'), findsOneWidget);
  });

  testWidgets('settings page drives the glass sliders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Glas-Unschärfe'), findsOneWidget);
    expect(find.text('Glas-Deckkraft'), findsOneWidget);
    expect(find.text('Haptik'), findsOneWidget);

    // Drag the blur slider to the left (fully transparent) and check the
    // live value actually changes — the glass surfaces re-render from it.
    final slider = tester.widget<Slider>(find.byType(Slider).first);
    expect(slider.value, moreOrLessEquals(0.65, epsilon: 0.01));
    await tester.drag(find.byType(Slider).first, const Offset(-300, 0));
    await tester.pumpAndSettle();
    final afterDrag = tester.widget<Slider>(find.byType(Slider).first);
    expect(afterDrag.value, lessThan(0.65));
  });

  testWidgets('developer tools module renders its tool sections',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    await tester.tap(find.byTooltip('All modules'));
    await tester.pumpAndSettle();

    // The menu panel is a lazy list: scroll the module into view first.
    await tester.scrollUntilVisible(
      find.descendant(
        of: find.byType(ModuleMenuPanel),
        matching: find.text('Developer Tools'),
      ),
      200,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(ModuleMenuPanel),
      matching: find.text('Developer Tools'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('JSON'), findsOneWidget);

    // The tool list is lazy: scroll the later sections into view.
    await tester.scrollUntilVisible(
      find.text('Encoders'),
      200,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();
    expect(find.text('Encoders'), findsOneWidget);

    // The tool list is lazy: scroll to the later sections.
    await tester.scrollUntilVisible(
      find.text('Hashes'),
      200,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 30,
    );
    await tester.pumpAndSettle();
    expect(find.text('Hashes'), findsOneWidget);
  });

  testWidgets('a module can be added to the favorite slots', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EToolsApp()));

    // Dashboard star buttons exist (the grid is lazily built).
    expect(find.byTooltip('Add favorite'), findsWidgets);

    await tester.tap(find.byTooltip('All modules'));
    await tester.pumpAndSettle();

    // Fill the first favorite slot via the first module row's star button
    // inside the menu panel (the barrier closes the menu on outside taps).
    await tester.tap(
      find
          .descendant(
            of: find.byType(ModuleMenuPanel),
            matching: find.byTooltip('Add favorite'),
          )
          .first,
    );
    await tester.pumpAndSettle();

    // One star toggled: the favorited module now shows its filled star in
    // the favorites section, its category row and on the dashboard card.
    expect(find.byTooltip('Remove favorite'), findsNWidgets(3));
  });
}
