# Channel iOS SDK

The Channel iOS SDK make is easy to integreate in-app messaging into your iOS app.

## Requirements

Our SDK is compatible with iOS apps supporting iOS 8.0 and above.

## Install the SDK
1. Go to our [Github releases page](https://github.com/Mogohichi/channel-ios-alpha/releases) and download and upzip Channel.framework.zip.
2. In Xcode, with your project open, click on "File" then "Add files to Project...".
3. Select __Channel.framework__ in the directory you just unzipped.
4. Checked "Copy items if needed".
5. Click "Add".
6. In "Embedded Binaries" Click "+"
7. Select __Channel.framework__.

## Configure the SDK
Once you downloaded the SDK, configure it with your Channel Application ID.
##### Objective-C
AppDelegate.m
```objective-c
#import "AppDelegate.h"
#import <Channel/Channel.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Channel setupWithApplicationId:@"app_VJSiM8Eq9FvnkdH1YBJ9_823TzGbzI5UOuiHbw6BANk"];
    // do any other necessary launch configuration

    return YES;
}

```

##### Swift
AppDelegate.swift
```swift
import UIKit
import Channel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Channel.setup(withApplicationId: "app_VJSiM8Eq9FvnkdH1YBJ9_823TzGbzI5UOuiHbw6BANk")
        // do any other necessary launch configuration

        return true
    }

```

## Integration
Channel provides a view controller that encapsulate all the functionalities.

You can send `userID` and `UserData` (optional) to Channel backend to help you identify which user you are communicating with.
The data will show up in user side bar.

##### Objective-c
```objective-c
- (IBAction)didTapButton:(id)sender {
    NSString* userID = @"AnyID";
    NSDictionary* userData = @{@"name":@"John",
        @"lastname": @"Doe"};
    UIViewController* vc = [Channel chatViewControllerWithUserID:userID userData:userData];
    vc.title = @"Your title here";
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
```

##### Swift
```swift
   @IBAction func didTapButton(_ sender: Any) {
        let userID = "AnyID"
        let userData = ["screen":"help",
                        "action":"contact"]
        let vc = Channel.chatViewController(withUserID: userID, userData: userData)
        vc.title = "Your title"
        self.navigationController?.pushViewController(vc, animated: true)
    }
```


## Questions?
We are always happy to help. Send us an email at channel@mogohichi.com
