import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:scrap_real/main.dart' as app;
import 'package:scrap_real/views/auth_views/login.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'package:scrap_real/views/main_views/user_profile.dart';
import 'package:scrap_real/views/scrapbook_views/create1.dart';
import 'package:scrap_real/views/scrapbook_views/create2.dart';
import 'package:scrap_real/views/scrapbook_views/create3.dart';
import 'package:scrap_real/views/scrapbook_views/create4.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final loginPage = find.byKey(const Key('loginPage'));
  final loginBack = find.byKey(const Key('loginBack'));
  final loginEmail = find.byKey(const Key('loginEmail'));
  final loginPass = find.byKey(const Key('loginPass'));
  final loginButton = find.byKey(const Key('loginButton'));
  final scrapbookTitle = find.byKey(const Key('scrapbookTitle'));
  final scrapbookCaption = find.byKey(const Key('scrapbookCaption'));
  final nextScrapbookOption1 = find.byKey(const Key('nextScrapbookOption1'));
  final nextScrapbookOption2 = find.byKey(const Key('nextScrapbookOption2'));
  final nextScrapbookOption3 = find.byKey(const Key('nextScrapbookOption3'));
  final createScrapbookButton = find.byKey(const Key('createScrapbookButton'));

  testWidgets('Creating a scrapbook', (WidgetTester tester) async {
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

    await tester.tap(find.byIcon(Icons.add_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(CreateScrapbookPage1), findsOneWidget);

    await tester.enterText(scrapbookTitle, 'Test Scrapbook');
    await tester.enterText(
        scrapbookCaption, 'Testing the create scrapbook feature');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.drag(
        find.byType(CreateScrapbookPage1), const Offset(0.0, -300));
    await tester.tap(nextScrapbookOption1);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byType(CreateScrapbookPage2), findsOneWidget);

    await tester.tap(find.text('Personal'));
    await tester.drag(
        find.byType(CreateScrapbookPage2), const Offset(0.0, -300));
    await tester.pumpAndSettle();
    await tester.tap(nextScrapbookOption2);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byType(CreateScrapbookPage3), findsOneWidget);

    await tester.tap(find.text('Travel'));
    await tester.tap(nextScrapbookOption3);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byType(CreateScrapbookPage4), findsOneWidget);

    await tester.tap(createScrapbookButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byType(UserProfilePage), findsOneWidget);
  });
}
