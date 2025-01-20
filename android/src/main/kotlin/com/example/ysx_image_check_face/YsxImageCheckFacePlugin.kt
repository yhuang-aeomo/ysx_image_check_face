package com.example.ysx_image_check_face

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.FaceDetector

/** YsxImageCheckFacePlugin */
class YsxImageCheckFacePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ysx_image_check_face")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "detectFaces") {
      val imagePath = call.argument<String>("imagePath")
      if (imagePath != null) {
          detectFaces(imagePath, result)
      } else {
          result.error("INVALID_ARGUMENT", "Image path is required", null)
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun detectFaces(imagePath: String, result: Result) {
    try {
        // 首先获取图片的尺寸信息
        val options = BitmapFactory.Options().apply {
            inJustDecodeBounds = true
        }
        BitmapFactory.decodeFile(imagePath, options)
        
        // 计算采样率，限制图片最大尺寸为 1024
        val maxSize = 1024
        var sampleSize = 1
        while (options.outWidth / sampleSize > maxSize || options.outHeight / sampleSize > maxSize) {
            sampleSize *= 2
        }
        
        // 加载适当大小的图片
        val bitmap = BitmapFactory.decodeFile(imagePath, BitmapFactory.Options().apply {
            inSampleSize = sampleSize
        })
        
        if (bitmap == null) {
            result.error("IMAGE_ERROR", "Cannot load image", null)
            return
        }

        // 转换为 RGB_565 格式
        val bitmap565 = bitmap.copy(Bitmap.Config.RGB_565, true)
        if (bitmap565 == null) {
            bitmap.recycle()
            result.error("CONVERSION_ERROR", "Cannot convert image to RGB_565", null)
            return
        }

        val maxFaces = 5
        val faceDetector = FaceDetector(bitmap565.width, bitmap565.height, maxFaces)
        val faces = arrayOfNulls<FaceDetector.Face>(maxFaces)
        val numberOfFaces = faceDetector.findFaces(bitmap565, faces)

        // 释放资源
        bitmap.recycle()
        bitmap565.recycle()

        result.success(numberOfFaces > 0)
        
    } catch (e: Exception) {
        result.error("DETECTION_ERROR", "Error during face detection: ${e.message}", null)
    }
  }

}
