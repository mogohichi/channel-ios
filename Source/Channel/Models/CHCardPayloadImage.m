//
//  CHCardPayloadImage.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardPayloadImage.h"

@implementation CHCardPayloadImage

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.imageURL = [NSURL URLWithString: json[@"url"]];
    }
    return self;
}

-(instancetype)initWithImageURL:(NSURL *)imageURL{
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
    }
    return self;
}

-(NSDictionary *)toJSON{
    return @{@"url":self.imageURL.absoluteString};
}

@end
