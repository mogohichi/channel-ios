//
//  CHConversation.m
//  Channel
//
//  Created by Apisit Toompakdee on 11/28/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHConversation.h"

@implementation CHConversation

- (instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if (self) {
        if (json[@"thread"] != nil) {
            self.thread = [[CHThread alloc]initWithJSON:json[@"thread"]];
        }
        if (json[@"latestMessage"] != nil) {
            self.latestMessage = [[CHMessage alloc]initWithJSON:json[@"latestMessage"]];
        }
        if (json[@"participants"] != nil) {
            NSMutableArray* list = [[NSMutableArray alloc]init];
            for (NSDictionary* dic in json[@"participants"]){
                CHUser* u = [[CHUser alloc]initWithJSON:dic];
                if (u != nil) {
                        [list addObject:u];
                }
            }
            self.participants = [NSArray arrayWithArray:list];
        }
        if (json[@"isAccept"] != nil) {
            self.isAccepted = [json[@"isAccept"] boolValue];
        }
        
    }
    return self;
}

@end
