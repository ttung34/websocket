import 'package:flutter/material.dart';
import 'package:flutter_websocket/auth/auth_screen.dart';
import 'package:flutter_websocket/page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';
    switch (routeName) {
      case loginRouter:
        return MaterialPageRoute(builder: (_) => const AuthScreenView());
      case intermediateRoute:
        return MaterialPageRoute(builder: (_) => const IntermediatePage());
      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }

  static const String loginRouter = '/login';
  static const String intermediateRoute = '/intermediate';
}
