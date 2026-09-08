import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  // 1. Singleton pattern
  static final TTSService _instance = TTSService._internal();
  static TTSService get instance => _instance;

  // Đối tượng thư viện
  late FlutterTts _flutterTts;

  // Biến đánh dấu trạng thái khởi tạo
  bool _isInitialized = false;

  // Private constructor
  TTSService._internal() {
    _flutterTts = FlutterTts();
  }

  // Khởi tạo engine (Gọi ở main.dart)
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Cấu hình ngôn ngữ (Tiếng Anh Mỹ)
      await _flutterTts.setLanguage("en-US");
      
      // Giọng điệu (Speech rate) - 1.0 là mặc định, 0.5 là chậm
      await _flutterTts.setSpeechRate(0.5);
      
      // Độ cao (Pitch)
      await _flutterTts.setPitch(1.0);

      // Cấu hình iOS đặc biệt (Cho phép phát tiếng cả khi đang gạt nút im lặng)
      await _flutterTts.setSharedInstance(true);
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      _isInitialized = true;
      debugPrint("TTS Service Initialized successfully.");
    } catch (e) {
      debugPrint("Lỗi khởi tạo TTS: $e");
    }
  }

  // Hàm phát âm thanh
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      debugPrint("TTS chưa được khởi tạo!");
      return;
    }
    
    if (text.isNotEmpty) {
      // Dừng âm thanh cũ (nếu đang phát) trước khi phát cái mới
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    }
  }

  // Hàm dừng phát
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
