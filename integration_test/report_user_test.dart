import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/home.dart';
import 'package:scrap_real/views/main_views/search.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final loginPage = find.byKey(const Key('loginPage'));
  final loginEmail = find.byKey(const Key('loginEmail'));
  final loginPass = find.byKey(const Key('loginPass'));
  final loginButton = find.byKey(const Key('loginButton'));
  final searchBar = find.byKey(const Key('searchBar'));
  final optionsMenu = find.byKey(const Key('optionsMenu'));
  final reportUserReason = find.byKey(const Key('reportUserReason'));
  final reportUserButton = find.byKey(const Key('reportUserButton'));

  testWidgets('Reporting a user for inappropriate content',
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
    await tester.pumpAndSettle();

    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tapAt(tester.getTopLeft(find.byIcon(Icons.search)));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);

    await tester.tapAt(tester.getBottomLeft(find.byType(SearchPage)));
    await tester.pumpAndSettle();
    await tester.enterText(searchBar, 'Sumant');
    await tester.pumpAndSettle();
    await tester.tap(find.text('@Sumant'));
    await tester.pumpAndSettle();

    expect(find.byType(UserProfilePage), findsOneWidget);

    await tester.tapAt(tester.getTopLeft(optionsMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report User'));
    await tester.pumpAndSettle();

    await tester.enterText(reportUserReason, 'Posted inappropriate content');
    await tester.tap(reportUserButton);
    await tester.pumpAndSettle();

    expect(find.byType(UserProfilePage), findsOneWidget);
  });
}
