import 'package:e_tools/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the E-Tools dashboard and all modules', (tester) async {
    await tester.pumpWidget(const EToolsApp());

    expect(find.text('E-Tools'), findsOneWidget);
    expect(find.text('Network & Connectivity'), findsOneWidget);
    expect(find.text('Diagnostics & Troubleshooting'), findsOneWidget);
  });
}
