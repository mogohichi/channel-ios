//
//  CHCardPayloadBase.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardPayloadBase.h"
#import "CHCardButton.h"

@implementation CHCardPayloadBase

- (NSDictionary*)toJSON{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        if (json[@"buttons"] != nil){
            NSArray* buttons = json[@"buttons"];
            NSMutableArray* list = [NSMutableArray new];
            for (NSDictionary* json in buttons){
                CHCardButton* button =[[CHCardButton alloc]initWithJSON:json];
                [list addObject:button];
            }
            self.buttons = [NSArray arrayWithObject:list];
        }
    }
    return self;
}

@end
