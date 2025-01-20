import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ysx_image_check_face_method_channel.dart';

abstract class YsxImageCheckFacePlatform extends PlatformInterface {
  /// Constructs a YsxImageCheckFacePlatform.
  YsxImageCheckFacePlatform() : super(token: _token);

  static final Object _token = Object();

  static YsxImageCheckFacePlatform _instance = MethodChannelYsxImageCheckFace();

  /// The default instance of [YsxImageCheckFacePlatform] to use.
  ///
  /// Defaults to [MethodChannelYsxImageCheckFace].
  static YsxImageCheckFacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YsxImageCheckFacePlatform] when
  /// they register themselves.
  static set instance(YsxImageCheckFacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> detectFaces(String imagePath) {
    throw UnimplementedError('detectFaces() has not been implemented.');
  }
}
