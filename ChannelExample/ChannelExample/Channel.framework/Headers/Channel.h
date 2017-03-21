//
//  Channel.h
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DidCheckUnseenMessage)(NSInteger numberOfNewMessages);

@interface Channel : NSObject

+ (void)setupWithApplicationId:(NSString* _Nonnull)appId;

+ (void)checkNewMessages:(DidCheckUnseenMessage _Nonnull)block;

+(UIViewController * _Nonnull)chatViewControllerWithUserID:(NSString* _Nonnull)userID userData:(NSDictionary* _Nullable)userData;


@end
