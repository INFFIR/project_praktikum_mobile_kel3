import 'package:get/get.dart';
import '../../audio_manager/audio_manager.dart';

class WelcomeController extends GetxController {
  final RxBool isMuted = false.obs;
  final RxString currentBgm = ''.obs;

  final AudioManager _audioManager = AudioManager.to;

  @override
  void onInit() {
    super.onInit();
    // Initialize the state from AudioManager
    isMuted.value = _audioManager.isMuted.value;
    currentBgm.value = _audioManager.currentBgm.value;

    // Sync state changes
    ever(_audioManager.isMuted, (bool value) {
      isMuted.value = value;
      print('isMuted changed to: $value');
    });

    ever(_audioManager.currentBgm, (String bgm) {
      currentBgm.value = bgm;
      print('Current BGM changed to: $bgm');
    });

    print('WelcomeController initialized');
  }

  @override
  void onClose() {
    super.onClose();
    print('WelcomeController closed');
  }

  /// Toggle mute/unmute music
  void toggleMusic() {
    // Just call the method without awaiting, since it's a void method
    _audioManager.toggleMute();
  }
}
