import 'package:flutter/material.dart';
import 'package:flutter_websocket/auth/auth_form.dart';

class AuthScreenView extends StatefulWidget {
  const AuthScreenView({super.key});

  @override
  State<AuthScreenView> createState() => _AuthScreenViewState();
}

class _AuthScreenViewState extends State<AuthScreenView> {
  bool _isLogin = true;

  void _toggleAuthMode(bool isLongin) {
    if (mounted) {
      setState(() {
        _isLogin = isLongin;
        print("Islogin: ${_isLogin}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? "Đăng nhập" : "Đăng ký"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AuthFormView(
          isLogin: _isLogin,
          onToggleMode: _toggleAuthMode,
        ),
      ),
    );
  }
}
