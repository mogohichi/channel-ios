//
//  CHSender.m
//  Channel
//
//  Created by Apisit Toompakdee on 2/2/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHSender.h"

@implementation CHSender

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.name = json[@"name"];
        self.publicID = json[@"clientID"];
        self.imageUrl = json[@"profilePictureURL"];
    }
    return self;
}

- (NSDictionary*)toJSON {
    NSMutableDictionary* json = [[NSMutableDictionary alloc]init];
    if (self.publicID != nil) {
        json[@"clientID"] = self.publicID;
    }
    
    if (self.name != nil) {
        json[@"name"] = self.name;
    }
    
    if (self.imageUrl != nil) {
        json[@"profilePictureURL"] = self.imageUrl;
    }
    
    return json;
}
@end
