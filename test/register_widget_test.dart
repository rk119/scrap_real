import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/auth_views/register.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    Firebase.initializeApp();
  });

  group('registration page test', () {
    testWidgets('empty text fields', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: RegisterPage())));

      await tester.pump();

      expect(find.text('Register'), findsNWidgets(2));
      expect(find.text('Create a new account'), findsOneWidget);

      final registerUsername = find.byKey(const Key('registerUsername'));
      expect(registerUsername, findsOneWidget);

      final registerEmail = find.byKey(const Key('registerEmail'));
      expect(registerEmail, findsOneWidget);

      final registerPass = find.byKey(const Key('registerPass'));
      expect(registerPass, findsOneWidget);

      final confirmPass = find.byKey(const Key('confirmPass'));
      expect(confirmPass, findsOneWidget);

      final registerButton = find.byKey(const Key('registerButton'));
      expect(registerButton, findsOneWidget);

      await tester.drag(find.byType(RegisterPage), const Offset(0.0, -300));
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Enter a min. of 6 characters'), findsOneWidget);
    });

    testWidgets('registration with invalid details',
        (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: RegisterPage())));

      await tester.pump();

      final registerUsername = find.byKey(const Key('registerUsername'));
      expect(registerUsername, findsOneWidget);
      await tester.enterText(registerUsername, 'username123');

      final registerEmail = find.byKey(const Key('registerEmail'));
      expect(registerEmail, findsOneWidget);
      await tester.enterText(registerEmail, 'email');

      final registerPass = find.byKey(const Key('registerPass'));
      expect(registerPass, findsOneWidget);
      await tester.enterText(registerPass, '1234');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.drag(find.byType(RegisterPage), const Offset(0.0, -300));

      final confirmPass = find.byKey(const Key('confirmPass'));
      expect(confirmPass, findsOneWidget);
      await tester.enterText(confirmPass, '123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.drag(find.byType(RegisterPage), const Offset(0.0, -300));

      expect(find.text('Username can be max of 10 characters'), findsOneWidget);
      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Enter a min. of 6 characters'), findsOneWidget);
      // expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('registration with valid details', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: RegisterPage())));

      await tester.pump();

      final registerUsername = find.byKey(const Key('registerUsername'));
      expect(registerUsername, findsOneWidget);
      await tester.enterText(registerUsername, 'username');

      final registerEmail = find.byKey(const Key('registerEmail'));
      expect(registerEmail, findsOneWidget);
      await tester.enterText(registerEmail, 'username@gmail.com');

      final registerPass = find.byKey(const Key('registerPass'));
      expect(registerPass, findsOneWidget);
      await tester.enterText(registerPass, '123456');

      final confirmPass = find.byKey(const Key('confirmPass'));
      expect(confirmPass, findsOneWidget);
      await tester.enterText(confirmPass, '123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      final registerButton = find.byKey(const Key('registerButton'));
      expect(registerButton, findsOneWidget);
      await tester.drag(find.byType(RegisterPage), const Offset(0.0, -300));

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Username can be max of 10 characters'), findsNothing);
      expect(find.text('Invalid email'), findsNothing);
      expect(find.text('Enter a min. of 6 characters'), findsNothing);
    });
  });
}
