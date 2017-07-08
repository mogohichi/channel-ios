//
//  ChannelUNUserNotificationCenter.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "ChannelUNUserNotificationCenter.h"
#import "CHHelper.h"
#import "Channel.h"
#import "CHClient.h"

@import UserNotifications;

@implementation ChannelUNUserNotificationCenter

+ (void)swizzleSelectors {
    injectToProperClass(@selector(setChannelUNDelegate:), @selector(setDelegate:), @[], [ChannelUNUserNotificationCenter class], [UNUserNotificationCenter class]);
    
    injectToProperClass(@selector(channelRequestAuthorizationWithOptions:completionHandler:),
                        @selector(requestAuthorizationWithOptions:completionHandler:), @[],
                        [ChannelUNUserNotificationCenter class], [UNUserNotificationCenter class]);
    injectToProperClass(@selector(channelGetNotificationSettingsWithCompletionHandler:),
                        @selector(getNotificationSettingsWithCompletionHandler:), @[],
                        [ChannelUNUserNotificationCenter class], [UNUserNotificationCenter class]);
}

static Class delegateUNClass = nil;
static NSArray* delegateUNSubclasses = nil;

- (void) setChannelUNDelegate:(id)delegate {
    
    delegateUNClass = getClassWithProtocolInHierarchy([delegate class], @protocol(UNUserNotificationCenterDelegate));
    delegateUNSubclasses = ClassGetSubclasses(delegateUNClass);
    
    injectToProperClass(@selector(channelUserNotificationCenter:willPresentNotification:withCompletionHandler:),
                        @selector(userNotificationCenter:willPresentNotification:withCompletionHandler:), delegateUNSubclasses, [ChannelUNUserNotificationCenter class], delegateUNClass);
    
    injectToProperClass(@selector(channelUserNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:),
                        @selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:), delegateUNSubclasses, [ChannelUNUserNotificationCenter class], delegateUNClass);
    
    [self setChannelUNDelegate:delegate];
}

static BOOL useCachedUNNotificationSettings;
static UNNotificationSettings* cachedUNNotificationSettings;

- (void)channelRequestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:(void (^)(BOOL granted, NSError *__nullable error))completionHandler {
    
    id wrapperBlock = ^(BOOL granted, NSError* error) {
        useCachedUNNotificationSettings = false;
        completionHandler(granted, error);
    };
    [self channelRequestAuthorizationWithOptions:options completionHandler:wrapperBlock];
}

- (void)channelGetNotificationSettingsWithCompletionHandler:(void(^)(UNNotificationSettings *settings))completionHandler {
    id wrapperBlock = ^(UNNotificationSettings* settings) {
        cachedUNNotificationSettings = settings;
        completionHandler(settings);
    };
    
    [self channelGetNotificationSettingsWithCompletionHandler:wrapperBlock];
}

- (void)channelUserNotificationCenter:(UNUserNotificationCenter *)center
              willPresentNotification:(UNNotification *)notification
                withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSUInteger completionHandlerOptions = UNNotificationPresentationOptionAlert;
    
    if ([self respondsToSelector:@selector(channelUserNotificationCenter:willPresentNotification:withCompletionHandler:)]){
        [self channelUserNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    }
    completionHandler(completionHandlerOptions);
}

// Apple's docs - Called to let your app know which action was selected by the user for a given notification.
- (void)channelUserNotificationCenter:(UNUserNotificationCenter *)center
       didReceiveNotificationResponse:(UNNotificationResponse *)response
                withCompletionHandler:(void(^)())completionHandler {
    
    if ([self respondsToSelector:@selector(channelUserNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)])
        [self channelUserNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
    
    //NSDictionary* aps = response.notification.request.content.userInfo[@"aps"];
    NSString* notificationID = response.notification.request.content.userInfo[@"id"];
    //post to server to track open from push notification
    if (notificationID != nil) {
        [[CHClient currentClient] markOpenFromPushNotification:notificationID];
    }
    NSString* pushType = response.notification.request.content.userInfo[@"cpt"];
    //cpt = Channel Push Type
    if (pushType != nil) {
        //c = converations
        //iam = in-app message
        if ([pushType isEqualToString:@"c"]){
            if ([[Channel shared].delegate respondsToSelector:@selector(channelUserDidTapPushNotificationTypeConversations)]) {
                [[Channel shared].delegate channelUserDidTapPushNotificationTypeConversations];
            }
        }else  if ([pushType isEqualToString:@"iam"]){
            if ([[Channel shared].delegate respondsToSelector:@selector(channelUserDidTapPushNotificationTypeInAppMessage)]) {
                [[Channel shared].delegate channelUserDidTapPushNotificationTypeInAppMessage];
            }
        }
    }

    completionHandler();
}

@end
