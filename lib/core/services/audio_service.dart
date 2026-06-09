import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCheckInSound() async {
    try {
      await _player.play(AssetSource('sounds/check_in.wav'));
    } catch (e) {
      print('Error playing check-in sound: $e');
    }
  }

  static Future<void> playCheckOutSound() async {
    try {
      await _player.play(AssetSource('sounds/check_out.wav'));
    } catch (e) {
      print('Error playing check-out sound: $e');
    }
  }
}
