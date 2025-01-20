import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ysx_image_check_face/ysx_image_check_face_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelYsxImageCheckFace platform = MethodChannelYsxImageCheckFace();
  const MethodChannel channel = MethodChannel('ysx_image_check_face');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
