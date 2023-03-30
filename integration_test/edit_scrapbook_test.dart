import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook1.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook2.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook3.dart';
import 'package:scrap_real/views/scrapbook_views/editScrapbook4.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final loginPage = find.byKey(const Key('loginPage'));
  final loginBack = find.byKey(const Key('loginBack'));
  final loginEmail = find.byKey(const Key('loginEmail'));
  final loginPass = find.byKey(const Key('loginPass'));
  final loginButton = find.byKey(const Key('loginButton'));
  final editScrapbookButton = find.byKey(const Key('editScrapbookButton'));
  final editScrapbookCaption = find.byKey(const Key('editScrapbookCaption'));

  testWidgets('Editing a scrapbook', (WidgetTester tester) async {
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

    expect(find.byType(UserProfilePage), findsOneWidget);

    await tester.tap(find.text('testing2'));
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getTopLeft(editScrapbookButton));
    await tester.pumpAndSettle();

    expect(find.byType(EditScrapbook1), findsOneWidget);

    await tester.enterText(editScrapbookCaption, 'Test Scrapbook');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(EditScrapbook1), const Offset(0.0, -300));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(EditScrapbook2), findsOneWidget);

    await tester.tap(find.text('Personal'));
    await tester.tap(find.text('Private'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(EditScrapbook3), findsOneWidget);

    await tester.tap(find.text('Travel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(EditScrapbook4), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(UserProfilePage), findsOneWidget);
  });
}
