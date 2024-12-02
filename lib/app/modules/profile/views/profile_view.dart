import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/profile_controller.dart';
import '../../components/bottom_navbar.dart';  // Import BottomNavBar

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 3.obs; // Menambahkan RxInt untuk currentIndex

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileInfo(context),
                const SizedBox(height: 16),
                _buildNavigationButtons(),
              ],
            ),
          )),
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          currentIndex: currentIndex.value, // Menggunakan .value untuk RxInt
          onTap: (index) {
            currentIndex.value = index; // Update currentIndex dengan RxInt
          },
        ),
      ),
    );
  }

  // Membuat AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        'My Profile',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: controller.updateProfile,
          child: const Text(
            'Apply',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProfilePicture(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.usernameController.text,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  controller.emailController.text,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: controller.openGoogleMaps, // Membuka Google Maps
                  child: Obx(() => Text(
                        controller.currentAddress.value.isEmpty
                            ? 'Alamat belum diatur'
                            : 'Alamat saat ini: ${controller.currentAddress.value}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.addressController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Masukkan alamat manual',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(255, 10, 10, 10),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    controller.updateManualAddress(value);
                  },
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEditProfileSheet(context),
            child: const Text(
              'Edit Profile >',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat gambar profil
  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: controller.imagePath.value.isNotEmpty
          ? FileImage(File(controller.imagePath.value))
          : null,
      child: controller.imagePath.value.isEmpty
          ? const Icon(Icons.person, size: 30, color: Colors.white)
          : null,
    );
  }

  // Tombol navigasi lainnya
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(Icons.favorite_border, 'Favorite', Colors.redAccent),
          _buildNavButton(
              Icons.shopping_bag_outlined, 'Orders', Colors.blueAccent),
          _buildNavButton(
              Icons.dashboard_outlined, 'Management', Colors.greenAccent),
        ],
      ),
    );
  }

  // Tombol untuk navigasi
  Widget _buildNavButton(IconData icon, String label, Color iconColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: () {},
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  // Menampilkan modal untuk edit profil
  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditProfileHeader(),
              const SizedBox(height: 24),
              _buildEditProfileForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Menampilkan header dari modal edit profil
  Widget _buildEditProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              controller.updateProfile();
              Get.back();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  // Form untuk input data profil
  Widget _buildEditProfileForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField(controller.usernameController, 'Username'),
          const SizedBox(height: 16),
          _buildTextField(controller.emailController, 'Email', readOnly: true),
          const SizedBox(height: 16),
          _buildAddressInputField(),
        ],
      ),
    );
  }

  // Field input untuk alamat
  Widget _buildAddressInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alamat',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat manual',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.fetchCurrentLocation(),
              icon: const Icon(Icons.gps_fixed),
              tooltip: 'Gunakan GPS',
            ),
          ],
        ),
      ],
    );
  }

  // Menampilkan field text
  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.grey[200],
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      readOnly: readOnly,
    );
  }

  // Fungsi untuk membuka lokasi di Google Maps
  void openGoogleMaps(double latitude, double longitude) async {
    String googleUrl = "https://www.google.com/maps?q=$latitude,$longitude";
    if (await canLaunch(googleUrl)) {
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Google Maps tidak dapat dibuka');
    }
  }
}
