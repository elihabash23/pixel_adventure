// Basic widget test for Pixel Adventure game

import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_adventure/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the app widget is created
    expect(find.byType(MyApp), findsOneWidget);

    // Note: Full game testing would require mocking Flame game components
    // and is beyond the scope of this basic smoke test
  });
}
