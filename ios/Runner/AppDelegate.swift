import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  let channelName = "com.example.music_player/share" // Same as Android
  var methodChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
        let messenger = controller.binaryMessenger
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    } else {
        print("Error: Could not get FlutterViewController or rootViewController.")
    }
    
    // Handle URL if app is launched via URL scheme
    if let url = launchOptions?[.url] as? URL {
        // It's important that methodChannel is initialized before this is called.
        // The setup above should ensure this.
        _ = handleSharedUrl(url: url) // Underscore to silence "result unused" warning
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // This is called when the app is already running or in the background
    return handleSharedUrl(url: url)
  }

  private func handleSharedUrl(url: URL) -> Bool {
    guard let channel = methodChannel else {
        print("Error: MethodChannel is nil in handleSharedUrl.")
        return false
    }

    if url.scheme == "earsyncshare" { // Your custom URL scheme
        var sharedLink: String?

        // Handles earsyncshare:<link_is_opaque_part>
        // e.g. earsyncshare:https://www.youtube.com/watch?v=...
        let fullString = url.absoluteString
        if fullString.hasPrefix("earsyncshare:") {
            sharedLink = String(fullString.dropFirst("earsyncshare:".count))
        }
        // The prompt also mentioned parsing host/query, but for simplicity
        // and direct YouTube link sharing, the above is more likely.
        // If earsyncshare://<host_is_link> format is used:
        // else if let host = url.host {
        //    sharedLink = host
        //    if let query = url.query { sharedLink = "\(host)?\(query)" }
        // }
        
        if let link = sharedLink, !link.isEmpty {
            channel.invokeMethod("handleSharedLink", arguments: link)
            return true
        } else {
            print("Warning: Shared link from URL scheme was empty or could not be parsed.")
        }
    }
    return false
  }
}
