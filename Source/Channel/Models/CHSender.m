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
        self.imageUrl = json[@"profilePictureURL"];
    }
    return self;
}
@end
