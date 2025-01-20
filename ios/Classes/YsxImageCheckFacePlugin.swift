import Flutter
import UIKit
import Vision

public class YsxImageCheckFacePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ysx_image_check_face", binaryMessenger: registrar.messenger())
    let instance = YsxImageCheckFacePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "detectFaces":
      handleDetectFaces(arguments: call.arguments, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleDetectFaces(arguments: Any?, result: @escaping FlutterResult) {
    guard let args = arguments as? [String: Any],
          let imagePath = args["imagePath"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENT",
                        message: "缺少图片路径参数",
                        details: nil))
      return
    }
    
    detectFaces(imagePath: imagePath) { hasFaces, error in
      if let error = error {
        result(FlutterError(code: "DETECTION_ERROR",
                          message: error.localizedDescription,
                          details: nil))
        return
      }
      result(hasFaces)
    }
  }

  private func detectFaces(imagePath: String, completion: @escaping (Bool, Error?) -> Void) {
    let imageURL = URL(fileURLWithPath: imagePath)
    
    guard let imageData = try? Data(contentsOf: imageURL),
          let cgImage = UIImage(data: imageData)?.cgImage else {
      completion(false, NSError(domain: "YsxImageCheckFace",
                              code: -1,
                              userInfo: [NSLocalizedDescriptionKey: "无法加载图片"]))
      return
    }
    
    let request = VNDetectFaceRectanglesRequest { request, error in
      if let error = error {
        completion(false, error)
        return
      }
      
      guard let results = request.results as? [VNFaceObservation] else {
        completion(false, nil)
        return
      }
      
      completion(!results.isEmpty, nil)
    }
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    do {
      try handler.perform([request])
    } catch {
      completion(false, error)
    }
  }
}
