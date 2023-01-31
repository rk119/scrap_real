import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
void main() {
  group('Login Tets', () { 
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final loginPage = find.byKey(const Key('loginPage'));
    final loginBack = find.byKey(const Key('loginBack'));
    final loginEmail = find.byKey(const Key('loginEmail'));
    final loginPass = find.byKey(const Key('loginPass'));
    final loginButton = find.byKey(const Key('loginButton'));

    testWidgets(
      'Enter login page from welcome page, and presses back button to go back to the welcome page',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(loginPage);
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(WelcomePage), findsNothing);
        expect(loginBack, findsOneWidget);

        await tester.tapAt(tester.getTopLeft(loginBack));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.byType(LoginPage), findsNothing);
        expect(find.byType(WelcomePage), findsOneWidget);
      }
    );

    testWidgets(
      'Enter login page from welcome page, enter the email and password, move to the user profile page after pressing login',
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
      }
    );
  });  
}