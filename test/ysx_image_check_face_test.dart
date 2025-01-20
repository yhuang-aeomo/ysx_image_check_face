import 'package:flutter_test/flutter_test.dart';
import 'package:ysx_image_check_face/ysx_image_check_face.dart';
import 'package:ysx_image_check_face/ysx_image_check_face_platform_interface.dart';
import 'package:ysx_image_check_face/ysx_image_check_face_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockYsxImageCheckFacePlatform
    with MockPlatformInterfaceMixin
    implements YsxImageCheckFacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> detectFaces(String imagePath) => Future.value(true);
}

void main() {
  final YsxImageCheckFacePlatform initialPlatform = YsxImageCheckFacePlatform.instance;

  test('$MethodChannelYsxImageCheckFace is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelYsxImageCheckFace>());
  });

  test('getPlatformVersion', () async {
    YsxImageCheckFace ysxImageCheckFacePlugin = YsxImageCheckFace();
    MockYsxImageCheckFacePlatform fakePlatform = MockYsxImageCheckFacePlatform();
    YsxImageCheckFacePlatform.instance = fakePlatform;

    expect(await ysxImageCheckFacePlugin.getPlatformVersion(), '42');
  });

  test('detectFaces', () async {
    YsxImageCheckFace ysxImageCheckFacePlugin = YsxImageCheckFace();
    expect(await ysxImageCheckFacePlugin.detectFaces(''), false);
  }); 
}
