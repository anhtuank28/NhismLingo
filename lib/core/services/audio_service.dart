import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._privateConstructor();
  static final AudioService instance = AudioService._privateConstructor();

  final AudioPlayer _player = AudioPlayer();

  // Sử dụng link tĩnh tạm thời (CDN) vì chưa có assets âm thanh thật trong dự án.
  // Trong tương lai chỉ cần đổi UrlSource thành AssetSource('audio/ding.mp3').
  static const String _dingUrl = 'sounds/correct.mp3';
  static const String _buzzUrl = 'sounds/wrong.mp3';
  static const String _fanfareUrl = 'sounds/victory.mp3';

  bool _isMuted = false;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  Future<void> playCorrectSound() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.play(AssetSource(_dingUrl), volume: 0.8);
  }

  Future<void> playWrongSound() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.play(AssetSource(_buzzUrl), volume: 0.5);
  }

  Future<void> playVictorySound() async {
    if (_isMuted) return;
    await _player.stop();
    await _player.play(AssetSource(_fanfareUrl), volume: 1.0);
  }

  void dispose() {
    _player.dispose();
  }
}
