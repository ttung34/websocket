import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_websocket/core/utils/app_router.dart';
import 'package:flutter_websocket/service/acoount_dialogs.dart';
import 'package:flutter_websocket/service/firebase_auth_service.dart';
import 'package:flutter_websocket/service/user_service.dart';
import 'package:image_picker/image_picker.dart';

class AccountPageView extends StatefulWidget {
  const AccountPageView({super.key});

  @override
  State<AccountPageView> createState() => _AccountPageViewState();
}

class _AccountPageViewState extends State<AccountPageView> {
  final AuthServvice _authServvice = AuthServvice();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  String? profileImageUrl;
  String fullName = '';
  String phoneNumber = '';
  String address = '';
  bool isLoading = true;

  Future<void> _loadUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    Map<String, dynamic>? userInfo = await _userService.getUserInfo();

    if (mounted) {
      if (userInfo != null) {
        setState(
          () {
            fullName = userInfo['fullName'] ?? '';
            phoneNumber = userInfo['phoneNumber'] ?? '';
            address = userInfo['address'] ?? '';
            profileImageUrl = userInfo['profileImageUrl'];
            isLoading = false;
          },
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickAndUpLoadImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      File imageFile = File(pickedFile.path);
      String? downloadUrl = await _userService.uploadProfileImage(imageFile);

      if (!mounted) return;
      setState(
        () {
          if (downloadUrl != null) {
            profileImageUrl = downloadUrl;
          }
          isLoading = false;
          if (downloadUrl != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật ảnh đại diện thành công'),
              ),
            );
          } else {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật ảnh đại diện thất bại'),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi ${e}"),
        ),
      );
    }
  }

  Future<void> _handleLogOut() async {
    try {
      await _authServvice.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.loginRouter,
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi đăng xuất: ${e}'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản của tôi"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () =>
                AccountDiglogs.showLogoutConfirmation(context, _handleLogOut),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: profileImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.grey[400],
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _pickAndUpLoadImage,
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thông tin cá nhân',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  AccountDiglogs.showEditProfileDialog(
                                      context,
                                      fullName,
                                      phoneNumber,
                                      address,
                                      _userService, (name, phone, addressnew) {
                                setState(() {
                                  fullName = name;
                                  phoneNumber = phone;
                                  address = addressnew;
                                });
                              }),
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("Họ và tên"),
                          subtitle: Text(
                              fullName.isNotEmpty ? fullName : "Chưa cập nhật"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text("Số điện thoại"),
                          subtitle: Text(fullName.isNotEmpty
                              ? phoneNumber
                              : "Chưa cập nhật"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text("Địa chỉ"),
                          subtitle: Text(
                              fullName.isNotEmpty ? address : "Chưa cập nhật"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle: Text(
                              FirebaseAuth.instance.currentUser?.email ??
                                  "Chưa cập nhật"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Đổi mật khẩu'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => AccountDiglogs.showChangePasswordDialog(
                              context, _userService),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onTap: () => AccountDiglogs.showLogoutConfirmation(
                              context, _handleLogOut),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
