
import 'ysx_image_check_face_platform_interface.dart';

class YsxImageCheckFace {
  Future<String?> getPlatformVersion() {
    return YsxImageCheckFacePlatform.instance.getPlatformVersion();
  }

  Future<bool> detectFaces(String imagePath) {
    return YsxImageCheckFacePlatform.instance.detectFaces(imagePath);
  }
}
