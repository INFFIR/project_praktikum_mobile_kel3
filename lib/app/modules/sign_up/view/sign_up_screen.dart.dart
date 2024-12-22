import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../connection/controllers/connection_controller.dart';

import '../controllers/auth_controller.dart.dart';

class SignUpScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ConnectionController connectionController = Get.find<ConnectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => authController.pickProfileImage(),
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: authController.profileImage.value != null
                        ? FileImage(authController.profileImage.value!)
                        : const AssetImage("assets/placeholder.png") as ImageProvider,
                    child: const Icon(Icons.camera_alt),
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: authController.usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: authController.addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: authController.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authController.register();
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}