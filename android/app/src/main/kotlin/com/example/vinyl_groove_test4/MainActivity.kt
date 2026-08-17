package com.example.vinyl_groove_test4

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "channel"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "show_message" -> {
                    val text = call.argument<String>("text")

                    Toast.makeText(this, text, Toast.LENGTH_SHORT).show()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
