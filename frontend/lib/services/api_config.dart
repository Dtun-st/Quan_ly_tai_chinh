import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Chạy trên web
      return "http://localhost:3000";
    } else if (Platform.isAndroid) {
      // Chạy trên Android emulator
      return "http://10.0.2.2:3000";
    } else if (Platform.isIOS) {
      // Chạy trên iOS simulator
      return "http://localhost:3000";
    } else {
      // Desktop
      return "http://localhost:3000";
    }
  }
}
