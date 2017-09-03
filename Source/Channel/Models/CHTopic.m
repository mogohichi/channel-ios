//
//  CHTopic.m
//  Channel
//
//  Created by Apisit Toompakdee on 9/1/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHTopic.h"

@implementation CHTopic

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.name = json[@"name"];
    }
    return self;
}


@end
