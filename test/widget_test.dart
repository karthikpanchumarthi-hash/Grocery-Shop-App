import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:groceryshopapp/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ARMartApp());

    // Verify that our app starts.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}