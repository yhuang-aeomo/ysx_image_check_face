import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ysx_image_check_face_platform_interface.dart';

/// An implementation of [YsxImageCheckFacePlatform] that uses method channels.
class MethodChannelYsxImageCheckFace extends YsxImageCheckFacePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ysx_image_check_face');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> detectFaces(String imagePath) async {
    final result = await methodChannel.invokeMethod<bool>('detectFaces', {'imagePath': imagePath});
    return result ?? false;
  }
}
