import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  setUpAll(() async {
    Firebase.initializeApp();
  });
  group('Login page test', () {
    testWidgets('empty text fields', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: LoginPage())));

      await tester.pump();

      expect(find.text('Login'), findsNWidgets(2));
      expect(find.text('Sign in to your account'), findsOneWidget);

      final loginEmail = find.byKey(const Key('loginEmail'));
      expect(loginEmail, findsOneWidget);

      final loginPass = find.byKey(const Key('loginPass'));
      expect(loginPass, findsOneWidget);

      final loginButton = find.byKey(const Key('loginButton'));
      expect(loginButton, findsOneWidget);

      await tester.drag(find.byType(LoginPage), const Offset(0.0, -300));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Enter a min. of 6 characters'), findsOneWidget);
    });
    testWidgets('Login with invalid details', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: LoginPage())));

      await tester.pump();

      final loginEmail = find.byKey(const Key('loginEmail'));
      expect(loginEmail, findsOneWidget);

      await tester.enterText(loginEmail, 'email');
      final loginPass = find.byKey(const Key('loginPass'));
      expect(loginPass, findsOneWidget);

      await tester.enterText(loginPass, '1234');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.drag(find.byType(LoginPage), const Offset(0.0, -300));
      final loginButton = find.byKey(const Key('loginButton'));

      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Enter a min. of 6 characters'), findsOneWidget);
    });
    testWidgets('registration with valid details', (WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) => const MaterialApp(home: LoginPage())));

      await tester.pump();

      final loginEmail = find.byKey(const Key('loginEmail'));
      expect(loginEmail, findsOneWidget);

      await tester.enterText(loginEmail, 'username@gmail.com');
      final loginPass = find.byKey(const Key('loginPass'));
      expect(loginPass, findsOneWidget);

      await tester.enterText(loginPass, '123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      final loginButton = find.byKey(const Key('loginButton'));

      expect(loginButton, findsOneWidget);

      await tester.drag(find.byType(LoginPage), const Offset(0.0, -300));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Username can be max of 10 characters'), findsNothing);
      expect(find.text('Invalid email'), findsNothing);
      expect(find.text('Enter a min. of 6 characters'), findsNothing);
    });
  });
}
