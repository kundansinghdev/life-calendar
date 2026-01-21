# Keep all classes in the app package
-keep class com.example.life_wallpaper.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep WallpaperService
-keep public class * extends android.service.wallpaper.WallpaperService

# Keep MethodChannel
-keepclassmembers class * {
    @io.flutter.plugin.common.MethodChannel.MethodCallHandler *;
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
