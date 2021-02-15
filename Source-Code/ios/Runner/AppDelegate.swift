import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

    GMSServices.provideAPIKey("AIzaSyDj8Hw-yyWCK5lJskEwu8EWMKHpLvp62hQ")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
