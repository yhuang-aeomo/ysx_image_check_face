import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:ysx_image_check_face/ysx_image_check_face.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final _ysxImageCheckFacePlugin = YsxImageCheckFace();
  bool hasFace = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  
  Future<void> initPlatformState() async {
    try {
      await _ysxImageCheckFacePlugin.getPlatformVersion() ?? 'Unknown platform version';
      final documentPath = await getApplicationDocumentsDirectory();
      final imagePath = '${documentPath.path}/test1.jpg';
      final result = await _ysxImageCheckFacePlugin.detectFaces(imagePath);
      setState(() {
        hasFace = result;
      });
    }catch (e) {
      log(e.toString());
    }    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('hasFace $hasFace'),
        ),
      ),
    );
  }
}
