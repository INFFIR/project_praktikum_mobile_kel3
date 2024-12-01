import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioManager extends GetxService {
  static AudioManager get to => Get.find(); // Access AudioManager instance

  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isMuted = false.obs; // Observable for mute/unmute
  final RxString currentBgm = ''.obs; // Observable for current BGM being played
  
  // Reactive map for available music with names and URLs
  final RxMap<String, String> availableMusic = <String, String>{
    'BGM 1': 'https://firebasestorage.googleapis.com/v0/b/praktikum-mobile-kel3-b1e1c.appspot.com/o/bgm%2Fbgm1.mp3?alt=media&token=8305ab2b-cc52-4507-9723-a2ba0054dd04',
    'BGM 2': 'https://firebasestorage.googleapis.com/v0/b/praktikum-mobile-kel3-b1e1c.appspot.com/o/bgm%2Fbgm2.mp3?alt=media&token=455fcf4c-92d1-432e-98b6-3fcd040cb92e',
    'BGM 3': 'https://firebasestorage.googleapis.com/v0/b/praktikum-mobile-kel3-b1e1c.appspot.com/o/bgm%2Fbgm3.mp3?alt=media&token=472cf624-4e30-452a-9174-b64a742a2d8c',
    'BGM 4': 'https://firebasestorage.googleapis.com/v0/b/praktikum-mobile-kel3-b1e1c.appspot.com/o/bgm%2Fbgm4.mp3?alt=media&token=472cf624-4e30-452a-9174-b64a742a2d8c',
    'BGM 5': 'https://firebasestorage.googleapis.com/v0/b/praktikum-mobile-kel3-b1e1c.appspot.com/o/bgm%2Fbgm5.mp3?alt=media&token=472cf624-4e30-452a-9174-b64a742a2d8c',
  }.obs;

  // Reactive volume control
  var volume = 1.0.obs;

  bool _isPlaying = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize the audio player with the default volume
    _audioPlayer.setVolume(volume.value);

    // Listen to player completion to potentially loop the music
    _audioPlayer.onPlayerComplete.listen((event) {
      if (currentBgm.value.isNotEmpty) {
        playBackgroundMusic(currentBgm.value, loop: true); // Loop the music if needed
      }
    });

    // Play default music if available
    if (availableMusic.isNotEmpty) {
      final defaultBgm = availableMusic.keys.first; // Use the first key as default
      playBackgroundMusic(defaultBgm, loop: true); // Start with the default track
    }

    print('AudioManager initialized and music started');
  }

  /// Play background music by its name with optional looping
  Future<void> playBackgroundMusic(String bgmName, {bool loop = false}) async {
    try {
      final bgmUrl = availableMusic[bgmName]; // Get the URL by its name
      if (bgmUrl == null) {
        print('Music not found: $bgmName');
        return; // Return early if the music name doesn't exist
      }

      if (_isPlaying && currentBgm.value == bgmName) {
        print('Music is already playing: $bgmName');
        return; // Return early if the same music is already playing
      }

      print('Starting music playback: $bgmName');
      
      // Start playing the background music from URL
      await _audioPlayer.setSourceUrl(bgmUrl);
      await _audioPlayer.setVolume(volume.value);
      await _audioPlayer.resume();

      // Update the current background music
      currentBgm.value = bgmName;

      // Set looping if necessary
      if (loop) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Set the release mode to loop
      } else {
        await _audioPlayer.setReleaseMode(ReleaseMode.release); // Otherwise, stop after playback
      }

      _isPlaying = true;
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  /// Mute or unmute the audio
  void toggleMute() {
    isMuted.value = !isMuted.value;
    _audioPlayer.setVolume(isMuted.value ? 0.0 : volume.value); // Set volume to 0 if muted
  }

  /// Set the volume
  void setVolume(double newVolume) {
    volume.value = newVolume; // Update the reactive volume value
    if (!isMuted.value) {
      _audioPlayer.setVolume(volume.value); // Apply the volume change if not muted
    }
  }
}