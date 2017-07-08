## Set up Channel SDK

#### AppDelegate.swift

```swift
import UIKit
import Channel
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Channel.setup(withPublishableKey: "YOUR_APPLICATION_KEY_HERE", detectScreenshot: true, detectShake: true)
        return true
    }
}

```

## Start messaging
Channels iOS SDK exposes a view controller which contains everything you need.  
You can either push to navigation controller or present modally.
```swift
let vc = Channel.channelViewController()
let nav = UINavigationController(rootViewController: vc)
self.present(nav, animated: true, completion: nil)
```
