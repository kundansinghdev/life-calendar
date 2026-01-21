
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.example.life_wallpaper/bridge');

  static Future<void> openWallpaperPicker() async {
    try {
      await _channel.invokeMethod('openWallpaperPicker');
    } on PlatformException catch (e) {
      debugPrint("Failed to open picker: ${e.message}");
    }
  }
}
