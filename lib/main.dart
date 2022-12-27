import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scrap_real/router/routing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Routing().routing.routeInformationParser,
      routerDelegate: Routing().routing.routerDelegate,
    );
  }
}
