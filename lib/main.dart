import 'package:flutter/material.dart';
import 'package:scrap_real/router/routing.dart';
import 'package:scrap_real/views/welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
