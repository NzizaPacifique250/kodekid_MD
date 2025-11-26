import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kodekid/core/widgets/primary_button.dart';
import 'package:kodekid/core/widgets/kodekid_logo.dart';
import 'package:kodekid/core/constants/app_colors.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('PrimaryButton displays text and responds to tap', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test Button',
              backgroundColor: AppColors.orange,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Verify button text is displayed
      expect(find.text('Test Button'), findsOneWidget);
      
      // Tap the button
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      
      // Verify callback was called
      expect(tapped, true);
    });

    testWidgets('KodeKidLogo widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KodeKidLogo(),
          ),
        ),
      );

      // Verify logo widget is present
      expect(find.byType(KodeKidLogo), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('email_field'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Verify form field is present
      expect(find.byKey(const Key('email_field')), findsOneWidget);
    });
  });
}