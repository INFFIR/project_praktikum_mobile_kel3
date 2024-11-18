import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioManager extends GetxService {
  static AudioManager get to => Get.find();  // Access AudioManager instance

  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isMuted = false.obs;  // Observable for mute/unmute
  final RxString currentBgm = ''.obs;  // Observable for current BGM being played
  final RxList<String> availableMusic = <String>[  // Reactive list for available BGM
    'bgm1.mp3',
    'bgm2.mp3',
    'bgm3.mp3',
    // Add more music files here
  ].obs;

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
        playBackgroundMusic(currentBgm.value, loop: true);  // Loop the music if needed
      }
    });

    // Play default music if available
    if (availableMusic.isNotEmpty) {
      playBackgroundMusic(availableMusic[0], loop: true);  // Start with the first track
    }

    print('AudioManager initialized and music started');
  }

  /// Play background music with optional looping
  Future<void> playBackgroundMusic(String bgmFile, {bool loop = false}) async {
    try {
      if (_isPlaying && currentBgm.value == bgmFile) {
        print('Music is already playing: $bgmFile');
        return;  // Return early if the same music is already playing
      }

      print('Starting music playback: $bgmFile');
      
      // Start playing the background music
      await _audioPlayer.setSource(AssetSource('bgm/$bgmFile'));
      await _audioPlayer.setVolume(volume.value);
      await _audioPlayer.resume();

      // Update the current background music
      currentBgm.value = bgmFile;

      // Set looping if necessary
      if (loop) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);  // Set the release mode to loop
      } else {
        await _audioPlayer.setReleaseMode(ReleaseMode.release);  // Otherwise, stop after playback
      }

      _isPlaying = true;
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  /// Mute or unmute the audio
  void toggleMute() {
    isMuted.value = !isMuted.value;
    _audioPlayer.setVolume(isMuted.value ? 0.0 : volume.value);  // Set volume to 0 if muted
  }

  /// Set the volume
  void setVolume(double newVolume) {
    volume.value = newVolume;  // Update the reactive volume value
    if (!isMuted.value) {
      _audioPlayer.setVolume(volume.value);  // Apply the volume change if not muted
    }
  }
}
