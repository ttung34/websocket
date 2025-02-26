import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static String get apiKeyGemini => dotenv.env['API_KEY_GENIMI_AI'] ?? '';
  static String get apiRealTime => dotenv.env['API_REAL_TIME'] ?? '';
}
