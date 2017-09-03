//
//  Channel.m
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import "Channel.h"
#import "CHConfiguration.h"
#import "UIViewController+Extension.h"
#import "CHControllers.h"
#import "CHClient.h"
#import <UIKit/UIKit.h>

#import "CHNotificationViewController.h"
#import "CHNotificationPresentationController.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@import UIKit;
@import UserNotifications;

@interface Channel()<UIViewControllerTransitioningDelegate, CHClientDelegate>

@end

@implementation Channel : NSObject

+(Channel *)shared{
    static Channel *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

+ (void)registerForPushNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == NO) {
                return;
            }
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            [Channel registerAsUNNotificationCenterDelegate];
        }];
    } else {
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings
         settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
         categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

+ (void)registerAsUNNotificationCenterDelegate {
    Class UNNofiCenterClass = NSClassFromString(@"UNUserNotificationCenter");
    UNUserNotificationCenter *curNotifCenter = [UNNofiCenterClass currentNotificationCenter];
    if (!curNotifCenter.delegate)
        curNotifCenter.delegate = (id)[self shared];
}

+ (void)setupWithApplicationId:(NSString*)appId{
    [Channel setupWithApplicationId:appId userID:nil userData:nil launchOptions:nil];
}

+ (void)setupWithApplicationId:(NSString*)appId userID:(NSString*)userID userData:(NSDictionary*)userData {
    [Channel setupWithApplicationId:appId userID:userID userData:userData launchOptions:nil];
}

+(void)setupWithApplicationId:(NSString *)appId launchOptions:(NSDictionary *)launchOptions {
    [Channel setupWithApplicationId:appId userID:nil userData:nil launchOptions:launchOptions];
}

static BOOL coldStartFromTappingOnPushNotification = NO;

+(void)setupWithApplicationId:(NSString *)appId userID:(NSString *)userID userData:(NSDictionary *)userData launchOptions:(NSDictionary *)launchOptions {
    [CHConfiguration sharedConfiguration].applicationId = appId;
    [Channel registerForPushNotifications];
    if (userID != nil) {
        [CHClient currentClient].userID = userID;
    }
    if (userData != nil) {
        [CHClient currentClient].userData = userData;
    }
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        coldStartFromTappingOnPushNotification = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [CHClient connectClientwithUserID:userID userData:userData block:^(NSError *error) {
            
        }];
    });
}

+(UIViewController *)chatViewControllerWithUserID:(NSString* _Nonnull)userID userData:(NSDictionary* _Nullable)userData{
    [CHClient currentClient].userID = userID;
    [CHClient currentClient].userData = userData;
    return [CHControllers channelViewController];
}

+(void)checkNewMessages:(DidCheckUnseenMessage)block{
    [[CHClient currentClient] checkNewMessages:^(NSInteger numberOfNewMesages) {
        block(numberOfNewMesages);
    }];
}


-(void)showLatestNotification{
    //fetch to see if there is new notification
    [[CHClient currentClient] checkNewNotification:^(CHNotification *notification, NSError *error) {
        if (error != nil){
            return;
        }
        if (notification == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController* rootViewController =  [UIApplication sharedApplication].delegate.window.rootViewController;
            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:bundle];
            CHNotificationViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"CHNotificationViewController"];
            
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.notification = notification;
            vc.transitioningDelegate = self;
            [rootViewController presentViewController:vc animated:YES completion:^{
                
            }];
        });
    }];
}

- (void)updateUserID:(NSString* _Nonnull)userID userData:(NSDictionary* _Nullable)userData{
    [CHClient currentClient].userID = userID;
    [CHClient currentClient].userData = userData;
    [[CHClient currentClient] updateClientDataWithUserID:[CHClient currentClient].userID userData:[CHClient currentClient].userData block:^(NSError *error) {
        
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[CHNotificationPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}


+ (void)pushNotificationEnabled:(BOOL)enabled{
    [[CHClient currentClient] pushNotificationEnabled:enabled];
}

- (void)appendTags:(NSDictionary*)tags{
    [[CHClient currentClient] appendTags:tags];
}

- (void)subscribeToTopic:(NSString* _Nonnull)topic {
    [[CHClient currentClient] subscribeToTopic:topic block:^(CHTopic *topics, NSError *error) {
        
    }];
}


- (void)startReceivingRealtimeUpdate {
    [[CHClient currentClient] subscribeUpdateFromServerWithNSNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kDidReceiveRealtimeMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRealtimeMessage:) name:@"kDidReceiveRealtimeMessage" object:nil];
}


- (void)didReceiveRealtimeMessage:(NSNotification*)info {
    CHMessage* message = info.userInfo[@"message"];
    if ([self.delegate respondsToSelector:@selector(channelDidReceiveRealtimeMessage:)]) {
        [self.delegate channelDidReceiveRealtimeMessage:message];
    }
}


@end
