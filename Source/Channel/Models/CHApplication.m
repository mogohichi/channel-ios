//
//  CHApplication.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/3/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHApplication.h"

@implementation CHApplicationSettings

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.publicChat = json[@"setting"];
        
    }
    return self;
}


@end

@implementation CHApplication

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.name = json[@"name"];
        if (json[@"data"] != nil) {
            self.settings = [[CHApplicationSettings alloc]initWithJSON:json[@"data"]];
        }
    }
    return self;
}

@end
