
package com.example.life_wallpaper

import android.content.ComponentName
import android.content.Intent
import android.app.WallpaperManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    
    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL = "com.example.life_wallpaper/bridge"
        private const val METHOD_OPEN_WALLPAPER_PICKER = "openWallpaperPicker"
    }
    
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                METHOD_OPEN_WALLPAPER_PICKER -> {
                    openWallpaperPicker(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onDestroy() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        super.onDestroy()
    }
    
    private fun openWallpaperPicker(result: MethodChannel.Result) {
        try {
            // Try to open specific wallpaper picker for this app
            val intent = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER)
            val component = ComponentName(this, LifeWallpaperService::class.java)
            intent.putExtra(WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT, component)
            
            startActivity(intent)
            result.success(true)
            Log.d(TAG, "Opened wallpaper picker successfully")
        } catch (e: Exception) {
            Log.w(TAG, "Failed to open specific wallpaper picker, trying generic", e)
            
            // Fallback to generic picker if specific one fails
            try {
                val intent = Intent(WallpaperManager.ACTION_LIVE_WALLPAPER_CHOOSER)
                startActivity(intent)
                result.success(true)
                Log.d(TAG, "Opened generic wallpaper chooser successfully")
            } catch (e2: Exception) {
                Log.e(TAG, "Failed to open wallpaper picker", e2)
                result.error("UNAVAILABLE", "Could not open wallpaper picker: ${e2.message}", null)
            }
        }
    }
}
