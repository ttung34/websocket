import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return null;
      DocumentSnapshot doc =
          await _firestore.collection('user').doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Lỗi người dùng thông tin: ${e}");
      return null;
    }
  }

  Future<bool> updateUserInfo({
    required String fullName,
    required String phoneNumber,
    String? address,
  }) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return false;
      await _firestore.collection('user').doc(userId).set(
        {
          'fullName': fullName,
          'phoneName': phoneNumber,
          'address': address,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print("Lỗi khi cập nhật thông tin: ${e}");
      return false;
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return null;
      String fileName =
          'profile_$userId.${path.extension(imageFile.path).replaceAll('.', '')}';
      Reference ref = _storage.ref().child('profile_images').child(fileName);

      UploadTask uploadtask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadtask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('user').doc(userId).update({
        'profileImageUrl': downloadUrl,
        'updateAt': FieldValue.serverTimestamp(),
      });
      return downloadUrl;
    } catch (e) {
      print("Lỗi khi upload ảnh: ${e}");
      return null;
    }
  }

   Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      // Xác thực lại người dùng với mật khẩu hiện tại
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      // Đổi mật khẩu mới
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print("Lỗi đổi mật khẩu: ${e}");
      return false;
    }
  }
}
