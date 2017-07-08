//
//  CHThread.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHThread.h"

@implementation CHThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)callDelegate:(CHMessage*)message{
    if ([self.delegate respondsToSelector:@selector(didAddMessage:)]){
        [self.delegate didAddMessage:message];
    }
}

-(void)setDelegate:(id<CHThreadDelegate>)delegate{
    _delegate = delegate;
}

- (void)addText:(NSString*)text{
    CHMessage* message = [[CHMessage alloc]initWithText:text];
    [self.messages insertObject:message atIndex:0];
    [self callDelegate:message];
}

- (void)addMessage:(CHMessage *)message{
    [self.messages addObject:message];
    [self callDelegate:message];
}


@end
