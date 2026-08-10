package com.example.vinyl_groove

import android.widget.Toast
import com.google.zxing.BarcodeFormat
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.MultiFormatReader
import com.google.zxing.NotFoundException
import com.google.zxing.PlanarYUVLuminanceSource
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

private val CHANNEL = "channel"

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "show_message" -> {
                    val text = call.argument<String>("text") ?: ""

                    Toast.makeText(this, text, Toast.LENGTH_SHORT).show()

                    result.success(null)
                }

                "barcode" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val width = call.argument<Int>("width")
                    val height = call.argument<Int>("height")

                    if (bytes == null || width == null || height == null) {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    try {
                        val source = PlanarYUVLuminanceSource(
                            bytes, width, height, 0, 0, width, height, false
                        )
                        val bitmap = BinaryBitmap(HybridBinarizer(source))

                        val reader = MultiFormatReader()
                        reader.setHints(
                            mapOf(
                                DecodeHintType.POSSIBLE_FORMATS to listOf(
                                    BarcodeFormat.EAN_13, BarcodeFormat.EAN_8
                                )
                            )
                        )
                        result.success(reader.decode(bitmap).text)
                    } catch (e: NotFoundException){
                        result.success(null)
                    }catch (e: Exception){
                        result.success(null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
