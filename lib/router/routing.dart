import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/views/forgot_pass.dart';
import 'package:scrap_real/views/login.dart';
import 'package:scrap_real/views/register.dart';
import 'package:scrap_real/views/welcome.dart';

class Routing {
  GoRouter routing = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.welcome, 
        path: '/', 
        pageBuilder: (context, state) {
          return const MaterialPage(child: WelcomePage());
        },
      ),

      GoRoute(
        name: RouteConstants.register, 
        path: '/register', 
        pageBuilder: (context, state) {
          return const MaterialPage(child: RegisterPage());
        },
      ),

      GoRoute(
        name: RouteConstants.login, 
        path: '/login', 
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        },
      ),

      GoRoute(
        name: RouteConstants.forgotPass, 
        path: '/forgot/pass', 
        pageBuilder: (context, state) {
          return const MaterialPage(child: ForgotPassPage());
        },
      ),
    ],
  );
}