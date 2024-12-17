import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../audio_manager/audio_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Enhanced Music Selection Dialog
  void _showMusicOptions(BuildContext context) {
    final AudioManager audioManager = AudioManager.to;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Background Music',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() => ListView.separated(
                      shrinkWrap: true,
                      itemCount: audioManager.availableMusic.keys.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        String bgmName =
                            audioManager.availableMusic.keys.toList()[index];
                        bool isCurrent =
                            audioManager.currentBgm.value == bgmName;

                        return ListTile(
                          title: Text(
                            bgmName,
                            style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrent ? Colors.blue : Colors.black,
                            ),
                          ),
                          trailing: isCurrent
                              ? const Icon(Icons.music_note, color: Colors.blue)
                              : IconButton(
                                  icon: const Icon(Icons.play_circle_outline),
                                  onPressed: () async {
                                    await audioManager.playBackgroundMusic(
                                        bgmName,
                                        loop: true);
                                    Get.back(); // Use Get.back() to match original implementation
                                  },
                                ),
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  // Enhanced Logout Method with Confirmation
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                try {
                  await FirebaseAuth.instance.signOut(); // Firebase logout
                  await GetStorage().erase(); // Clear stored data

                  Get.offAllNamed('/login'); // Redirect to login page
                } catch (e) {
                  Get.snackbar(
                    'Logout Error',
                    'Failed to log out. Please try again.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  print('Error during logout: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AudioManager audioManager = AudioManager.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Audio Settings Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio Settings',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                      ),
                      const SizedBox(height: 16),
                      // Volume control slider
                      Text('Volume',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Obx(() {
                        return Slider(
                          value: audioManager.volume.value,
                          min: 0.0,
                          max: 1.0,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.blue.shade100,
                          onChanged: (value) {
                            audioManager.setVolume(value);
                          },
                        );
                      }),

                      // Mute/unmute toggle
                      Obx(() {
                        return SwitchListTile(
                          title: const Text('Mute'),
                          value: audioManager.isMuted.value,
                          onChanged: (value) {
                            audioManager.toggleMute();
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Button to select background music
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showMusicOptions(context),
                  icon: const Icon(Icons.music_note),
                  label: const Text('Choose Background Music'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Logout button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 2, 0, 16), // Changed to a more vibrant red
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
