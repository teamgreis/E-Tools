import 'package:e_tools/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the E-Tools dashboard and every module', (tester) async {
    await tester.pumpWidget(const EToolsApp());

    expect(find.text('E-Tools'), findsOneWidget);
    expect(find.text('Network & Connectivity'), findsOneWidget);

    // The dashboard is a scrollable grid: modules below the fold only exist
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
}
