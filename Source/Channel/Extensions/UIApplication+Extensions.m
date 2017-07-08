//
//  UIApplication+Extensions.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "UIApplication+Extensions.h"
#import <objc/runtime.h>
#import "UIApplicationDelegate+Channel.h"
#import "CHHelper.h"
#import "ChannelUNUserNotificationCenter.h"
@import UserNotifications;

@implementation UIApplication (Extensions)

+ (void)load {
    injectToProperClass(@selector(setChannelDelegate:), @selector(setDelegate:), @[], [ChannelAppDelegate class], [UIApplication class]);
    [ChannelUNUserNotificationCenter swizzleSelectors];
}


@end
