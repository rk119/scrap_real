import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrap_real/router/route_constants.dart';
import 'package:scrap_real/views/forgot_pass.dart';
import 'package:scrap_real/views/login.dart';
import 'package:scrap_real/views/register.dart';
import 'package:scrap_real/views/welcome.dart';

double offsetX = 0;

void routePush(BuildContext context, String name){
  context.pushNamed(name);
  offsetX = 1;
}

void routePushReplacement(BuildContext context, String name){
  context.pushReplacementNamed(name);
  offsetX = -1;
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context, 
  required GoRouterState state, 
  required Widget child,
  required double offsetx
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => 
        SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: Offset(offsetx, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: child),  
    );
}

class Routing {
  GoRouter routing = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.welcome, 
        path: '/', 
        // pageBuilder: (context, state) {
        //   return const MaterialPage(child: WelcomePage());
        // },
        pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const WelcomePage(), offsetx: offsetX),
      ),

      GoRoute(
        name: RouteConstants.register, 
        path: '/register', 
        // pageBuilder: (context, state) {
        //   return const MaterialPage(child: RegisterPage());
        // },
        pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const RegisterPage(), offsetx: offsetX),
      ),

      GoRoute(
        name: RouteConstants.login, 
        path: '/login', 
        // pageBuilder: (context, state) {
        //   return const MaterialPage(child: LoginPage());
        // },
        pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const LoginPage(), offsetx: offsetX),
      ),

      GoRoute(
        name: RouteConstants.forgotPass, 
        path: '/forgot/pass', 
        // pageBuilder: (context, state) {
        //   return const MaterialPage(child: ForgotPassPage());
        // },
         pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ForgotPassPage(), offsetx: offsetX),
      ),
    ],
  );
}