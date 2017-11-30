//
//  CHUser.m
//  Channel
//
//  Created by Apisit Toompakdee on 11/30/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHUser.h"

@implementation CHUser
- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.publicID = json[@"clientID"];
        self.appUserID = json[@"userID"];
        self.data = json[@"userData"];
        self.isActive = [json[@"isActive"] boolValue];
    }
    return self;
}
@end


