import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Primary button displays and responds to tap', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                tapped = true;
              },
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('Text field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: InputDecoration(hintText: 'Enter code'),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'print("Hello World")');
      await tester.pump();

      expect(find.text('print("Hello World")'), findsOneWidget);
    });

    testWidgets('Scaffold with app bar displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('KodeKid'),
            ),
          ),
        ),
      );

      expect(find.text('KodeKid'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}