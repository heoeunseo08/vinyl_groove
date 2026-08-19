package com.example.vinyl_groove_test5

import android.widget.Toast
import androidx.core.content.withStyledAttributes
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
                }

                "barcode" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val wid = call.argument<Int>("width")
                    val height = call.argument<Int>("height")

                    if (bytes == null || wid == null || height == null) {
                        result.success(null)
                        return@setMethodCallHandler
                    }

                    try {
                        val source = PlanarYUVLuminanceSource(
                            bytes, wid, height, 0, 0, wid, height, false
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

                    } catch (e: NotFoundException) {
                        result.success(null)
                    } catch (e: Exception) {
                        result.success(null)
                    }
                }
            }
        }
    }

}
