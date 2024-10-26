import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/sign_up/controllers/auth_controller.dart.dart';

class SignUpScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => authController.pickProfileImage(),
              child: Obx(() {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: authController.profileImage.value != null
                      ? FileImage(authController.profileImage.value!)
                      : AssetImage("assets/placeholder.png") as ImageProvider,
                  child: Icon(Icons.camera_alt),
                );
              }),
            ),
            TextField(
              controller: authController.usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: authController.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: authController.addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: authController.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.register();
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
