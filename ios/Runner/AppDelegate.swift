import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "sample.ko2ic/toPlattformScreen",
                                                  binaryMessenger: controller)
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if "toPlattformScreen" == call.method {
                self.toPlattformScreen()
                result(true)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func toPlattformScreen() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let storyboard: UIStoryboard = UIStoryboard(name: "Next", bundle: nil)
        let next = storyboard.instantiateInitialViewController()
        controller.present(next!, animated: true, completion: nil)
    }
}
