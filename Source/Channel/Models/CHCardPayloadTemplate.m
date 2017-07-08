//
//  CHCardPayloadTemplate.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/20/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardPayloadTemplate.h"

@implementation CHCardPayloadTemplate

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.templateType = json[@"templateType"];
        self.url = json[@"url"];
    }
    return self;
}

-(NSDictionary *)toJSON{
    return nil;
}

@end
