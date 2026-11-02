import 'package:flutter/services.dart';

/// Layanan Suara Pelafalan Bahasa Korea (Hangeul Audio & Phonetics Service):
/// 1. Memutar suara pelafalan asli bahasa Korea (`ko-KR`) via Native Android TextToSpeech Engine
/// 2. Mendukung kecepatan Normal (0.88x) dan Lambat/Detail (0.50x) untuk belajar artikulasi
/// 3. Mendukung pemutaran suara per huruf penyusun (Jamo), per suku kata, maupun kalimat TOPIK I.
class HangeulAudioService {
  static const MethodChannel _channel =
      MethodChannel('saturnus.app/korean_tts');

  static const Map<String, String> _jamoPhoneticMap = {
    'ㄱ': '기역 (그)',
    'ㄴ': '니은 (느)',
    'ㄷ': '디귿 (드)',
    'ㄹ': '리을 (르)',
    'ㅁ': '미음 (므)',
    'ㅂ': '비읍 (브)',
    'ㅅ': '시옷 (스)',
    'ㅇ': '이응',
    'ㅈ': '지읒 (즈)',
    'ㅊ': '치읓 (츠)',
    'ㅋ': '키읔 (크)',
    'ㅌ': '티읕 (트)',
    'ㅍ': '피읖 (프)',
    'ㅎ': '히읗 (흐)',
    'ㅏ': '아',
    'ㅑ': '야',
    'ㅓ': '어',
    'ㅕ': '여',
    'ㅗ': '오',
    'ㅛ': '요',
    'ㅜ': '우',
    'ㅠ': '유',
    'ㅡ': '으',
    'ㅣ': '이',
    'ㅘ': '와',
  };

  static Future<void> speak(
    String hangeulText, {
    bool slow = false,
  }) async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await _channel.invokeMethod('speakKorean', {
        'text': hangeulText,
        'rate': slow ? 0.50 : 0.88,
        'pitch': 1.0,
      });
    } catch (_) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> speakJamo(String jamo) async {
    final spokenText = _jamoPhoneticMap[jamo] ?? jamo;
    await speak(spokenText, slow: true);
  }

  static Future<void> speakStepByStep({
    required List<String> jamoParts,
    required String fullWord,
  }) async {
    for (final jamo in jamoParts) {
      final spoken = _jamoPhoneticMap[jamo] ?? jamo;
      await speak(spoken, slow: true);
      await Future.delayed(const Duration(milliseconds: 950));
    }
    await Future.delayed(const Duration(milliseconds: 300));
    await speak(fullWord, slow: false);
  }
}
