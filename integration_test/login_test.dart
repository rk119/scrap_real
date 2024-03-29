import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  final loginPage = find.byKey(const Key('loginPage'));
  final loginBack = find.byKey(const Key('loginBack'));
  final loginEmail = find.byKey(const Key('loginEmail'));
  final loginPass = find.byKey(const Key('loginPass'));
  final loginButton = find.byKey(const Key('loginButton'));
  final settingsMenu = find.byKey(const Key('settingsMenu'));
  final logoutButton = find.byKey(const Key('logoutButton'));
  final logoutButton2 = find.byKey(const Key('logoutButton2'));

  testWidgets('Logging into and logging out of the app',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(loginPage);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(WelcomePage), findsNothing);
    expect(loginEmail, findsOneWidget);
    expect(loginPass, findsOneWidget);

    await tester.enterText(loginEmail, 'wafinzr@gmail.com');
    await tester.enterText(loginPass, '123456');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(UserProfilePage), findsOneWidget);

    await tester.tap(settingsMenu);
    await tester.tapAt(tester.getTopLeft(settingsMenu));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(UserSettingsPage), findsOneWidget);

    await tester.drag(find.byType(UserSettingsPage), const Offset(0.0, -300));
    await tester.tap(logoutButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(logoutButton2);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(WelcomePage), findsOneWidget);
  });
}
