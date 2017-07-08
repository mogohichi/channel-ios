//
//  CHPostback.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHPostback.h"

@implementation CHPostback

- (instancetype)initWithPayload:(NSString *)payload
{
    self = [super init];
    if (self) {
        self.payload = payload;
    }
    return self;
}


- (NSDictionary*)toJSON{
    if (self.payload != nil){
        return @{@"payload":self.payload};
    }
    return nil;
}


@end
