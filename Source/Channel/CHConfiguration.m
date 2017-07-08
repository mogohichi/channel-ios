//
//  CHConfiguration.m
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import "CHConfiguration.h"
@import UIKit;

@implementation CHConfiguration

+ (instancetype)sharedConfiguration {
    static CHConfiguration *sharedConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfiguration = [self new];
    });
    return sharedConfiguration;
}

-(id)copyWithZone:(__unused NSZone *)zone{
    CHConfiguration *copy = [self.class new];
    copy.applicationId = self.applicationId;
    return copy;
}

@end
