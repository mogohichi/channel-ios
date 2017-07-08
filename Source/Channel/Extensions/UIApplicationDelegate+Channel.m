//
//  UIApplicationDelegate+Channel.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "UIApplicationDelegate+Channel.h"
#import <UIKit/UIKit.h>
#import "CHHelper.h"
#import <objc/runtime.h>
#import "CHClient.h"

@implementation ChannelAppDelegate

static Class delegateClass = nil;

static NSArray* delegateSubclasses = nil;

+(Class)delegateClass {
    return delegateClass;
}

- (void) setChannelDelegate:(id<UIApplicationDelegate>)delegate {
    
    if (delegateClass) {
        [self setChannelDelegate:delegate];
        return;
    }
    
    Class newClass = [ChannelAppDelegate class];
    
    delegateClass = getClassWithProtocolInHierarchy([delegate class], @protocol(UIApplicationDelegate));
    delegateSubclasses = ClassGetSubclasses(delegateClass);
    
    injectToProperClass(@selector(channelApplicationDidEnterBackground:),
                        @selector(applicationDidEnterBackground:), delegateSubclasses, newClass, delegateClass);
    
    injectToProperClass(@selector(channellDidRegisterForRemoteNotifications:deviceToken:),
                        @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), delegateSubclasses, newClass, delegateClass);
    
    injectToProperClass(@selector(channelRemoteSilentNotification:UserInfo:fetchCompletionHandler:),
                        @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:), delegateSubclasses, newClass, delegateClass);
    
    
    [self setChannelDelegate:delegate];
}

- (void)channellDidRegisterForRemoteNotifications:(UIApplication*)app deviceToken:(NSData*)deviceToken {
    
    //save token
    [[CHClient currentClient] saveDeviceToken:deviceToken];
    
    if ([self respondsToSelector:@selector(channellDidRegisterForRemoteNotifications:deviceToken:)])
        [self channellDidRegisterForRemoteNotifications:app deviceToken:deviceToken];
}

- (void)channelApplicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"extra thing");
    
    // this looks like recursion, but because the insides of the methods are swapped, we are actually calling the original implementation of the method
    if ([self respondsToSelector:@selector(channelApplicationDidEnterBackground:)])
        [self channelApplicationDidEnterBackground:application];
}

- (void) channelRemoteSilentNotification:(UIApplication*)application UserInfo:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult)) completionHandler {
    
    BOOL callExistingSelector = [self respondsToSelector:@selector(channelRemoteSilentNotification:UserInfo:fetchCompletionHandler:)];
    
    if (callExistingSelector) {
        [self channelRemoteSilentNotification:application UserInfo:userInfo fetchCompletionHandler:completionHandler];
        return;
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
