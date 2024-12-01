import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../audio_manager/audio_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Show dialog to select background music
  void _showMusicOptions(BuildContext context) {
    final AudioManager audioManager = AudioManager.to;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Background Music'),
          content: SizedBox(
            width: double.maxFinite,
            child: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: audioManager.availableMusic.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String bgmName = audioManager.availableMusic.keys.toList()[index];
                bool isCurrent = audioManager.currentBgm.value == bgmName;
                return ListTile(
                  title: Text(bgmName), // Display the name of the music
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: isCurrent
                        ? null  // Don't re-play the same music
                        : () async {
                            await audioManager.playBackgroundMusic(bgmName, loop: true);
                            Get.back();  // Close the dialog
                          },
                  ),
                  leading: isCurrent
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: isCurrent
                      ? null  // Don't do anything if it's already playing
                      : () async {
                          await audioManager.playBackgroundMusic(bgmName, loop: true);
                          Get.back();  // Close the dialog
                        },
                );
              },
            )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AudioManager audioManager = AudioManager.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();  // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Volume control slider
            const Text('Volume'),
            Obx(() {
              return Slider(
                value: audioManager.volume.value,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  audioManager.setVolume(value);  // Update volume in AudioManager
                },
              );
            }),
            const SizedBox(height: 16),
            // Mute/unmute toggle
            Obx(() {
              return SwitchListTile(
                title: const Text('Mute'),
                value: audioManager.isMuted.value,
                onChanged: (value) {
                  audioManager.toggleMute();  // Toggle mute state
                },
              );
            }),
            const SizedBox(height: 16),
            // Button to select background music
            ElevatedButton(
              onPressed: () => _showMusicOptions(context),
              child: const Text('Choose Background Music'),
            ),
          ],
        ),
      ),
    );
  }
}
