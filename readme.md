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
8. Create a new `Run Script Phase` in your app’s target's `Build Phases` and paste the following snippet in the script text field.
```
bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/Channel.framework/strip-frameworks.sh"
```
This step is required to work around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) when archiving universal binaries.

9. Add `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` to a info.plist file.


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

#### More methods in setting up.
Some app might want to enable Channel only for authroized user. If you already have your `UserID` and other `userData`.   Channel also provides these helper methods

```objective-c
+ (void)setupWithApplicationId:(NSString* _Nonnull)appId;
+ (void)setupWithApplicationId:(NSString* _Nonnull)appId userID:(NSString* _Nullable)userID userData:(NSDictionary* _Nullable)userData;
+ (void)setupWithApplicationId:(NSString* _Nonnull)appId launchOptions:(NSDictionary* _Nullable)launchOptions;
+ (void)setupWithApplicationId:(NSString* _Nullable)appId userID:(NSString* _Nullable)userID userData:(NSDictionary* _Nullable)userData launchOptions:(NSDictionary* _Nullable)launchOptions;;
```
```swift
open class func setup(withApplicationId appId: String)
open class func setup(withApplicationId appId: String, userID: String?, userData: [AnyHashable : Any]?)
open class func setup(withApplicationId appId: String, launchOptions: [AnyHashable : Any]? = nil)
open class func setup(withApplicationId appId: String?, userID: String?, userData: [AnyHashable : Any]?, launchOptions: [AnyHashable : Any]? = nil)
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

## Checking new message
Sometimes you want to notify a client when you sent some message from our backend.
#### Objective-C
```objective-c
 [Channel checkNewMessages:^(NSInteger numberOfNewMessages) {
        if (numberOfNewMessages > 0){
            NSString* title = [NSString stringWithFormat:@"You have new %ld messages",numberOfNewMessages];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* view = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //open chat view 
            }];
            [alert addAction:view];
        
            UIAlertAction* later = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:later];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
```

#### Swift
```swift
Channel.checkNewMessages { (numberOfNewMessages) in
            if numberOfNewMessages > 0 {
                let alert = UIAlertController(title: "", message: "You have \(numberOfNewMessages) new mesage", preferredStyle: .alert)
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { (_) in
                   //do something or open Channel chat view controller
                })
                alert.addAction(viewAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                   
                })
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
```

## In-app notification
This method allows you to check if there is new in-app notification to the client.

#### Objective-C
```objective-c
[[Channel shared] showLatestNotification];
```
#### Swift
```swift
Channel.shared().showLatestNotification()
```

#### Delegate 
```ChannelDelegate```
There are delegates methods for in-app notification.

#### Objective-C
```objective-c
@protocol ChannelDelegate <NSObject>

@optional
- (void)channelUserDidTapButtonNotificationView:(CHNotification* _Nonnull)notification button:(CHNotificationButton* _Nonnull)button;
@optional
- (void)channelUserDidTapPushNotificationTypeConversations;
@optional
- (void)channelUserDidTapPushNotificationTypeInAppMessage;
@end

```

#### Swift
```swift
optional public func channelUserDidTapButtonNotificationView(_ notification: CHNotification, button: CHNotificationButton)
optional public func channelUserDidTapPushNotificationTypeConversations()
optional public func channelUserDidTapPushNotificationTypeInAppMessage()
```

## Push notification
If you have push notification capability enabled in your app. Channel SDK will do everything for you.  
However, if you want to provide user to opt-out from a push notification. This is disable   
You can call the method below passing boolean value to it.
```objective-c
[Channel pushNotificationEnabled:YES];
```
```swift
Channel.pushNotificationEnabled(true)
```


---
## Questions?
We are always happy to help. Send us an email at channel@mogohichi.com
