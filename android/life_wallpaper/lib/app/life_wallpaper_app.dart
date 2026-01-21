import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';

class LifeWallpaperApp extends StatelessWidget {
  const LifeWallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Wallpaper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const PremiumSplashScreen(),
    );
  }
}
