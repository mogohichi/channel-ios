//
//  CHNotification.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHNotification.h"

@implementation CHNotification

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        
        if (![json[@"data"] isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary* notification = json[@"data"][@"notification"];
        if (notification == nil){
            return nil;
        }
        self.publicID = json[@"publicID"];
        self.type = notification[@"type"];
        self.payload = [[CHNotificationPayload alloc]initWithJSON:notification[@"payload"]];
    }
    return self;
}

@end
