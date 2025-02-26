import 'package:firebase_auth/firebase_auth.dart';

class AuthServvice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng nhập
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Lỗi: ${e}");
      throw Exception("Đăng nhập thấp bại: ${e}");
    }
  }

  // Đăng ký người dùng
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Looix ${e}");
      throw Exception("Đăng ký thất bại: ${e}");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
