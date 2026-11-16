import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creditsea_app/app/app.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CreditSeaApp());
    expect(find.byType(CreditSeaApp), findsOneWidget);

    // Advance splash screen transition
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 600));

    // Cleanup active widget tree so continuous timers are disposed
    await tester.pumpWidget(const SizedBox());
  });
}
