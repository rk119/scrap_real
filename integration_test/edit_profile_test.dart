import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/settings_views/edit_profile.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final loginPage = find.byKey(const Key('loginPage'));
  final loginEmail = find.byKey(const Key('loginEmail'));
  final loginPass = find.byKey(const Key('loginPass'));
  final loginButton = find.byKey(const Key('loginButton'));
  final settingsMenu = find.byKey(const Key('settingsMenu'));
  final editProfileButton = find.byKey(const Key('editProfileButton'));
  final editUsername = find.byKey(const Key('editUsername'));
  final editBio = find.byKey(const Key('editBio'));
  final saveEditButton = find.byKey(const Key('saveEditButton'));

  testWidgets('Editing user profile', (WidgetTester tester) async {
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
    await tester.pumpAndSettle();

    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tapAt(tester.getTopLeft(settingsMenu));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(UserSettingsPage), findsOneWidget);

    await tester.tap(editProfileButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(EditProfilePage), findsOneWidget);

    await tester.enterText(editUsername, 'wafinzr');
    await tester.enterText(editBio, 'Life is fun.');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(EditProfilePage), const Offset(0.0, -300));
    await tester.tap(saveEditButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(UserProfilePage), findsOneWidget);
  });
}
