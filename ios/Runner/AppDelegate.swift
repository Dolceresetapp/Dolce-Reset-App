import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Retain channel to prevent ARC from deallocating the handler
  private var deviceChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // MethodChannel for device detection (iPad vs iPhone)
    let controller = window?.rootViewController as! FlutterViewController
    deviceChannel = FlutterMethodChannel(
      name: "com.dolceresetltd.app/device",
      binaryMessenger: controller.binaryMessenger
    )
    deviceChannel?.setMethodCallHandler { (call, result) in
      if call.method == "isIPad" {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        NSLog("[AppDelegate] isIPad check: \(isPad)")
        result(isPad)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
