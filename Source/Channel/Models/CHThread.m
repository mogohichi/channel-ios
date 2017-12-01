//
//  CHThread.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHThread.h"
#import "CHMessage.h"

@implementation CHThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _publicID = json[@"ID"];
        _threadOwnerClientID = json[@"clientID"];
        self.nextMessagesURL = json[@"next"];
    }
    return self;
}

- (instancetype _Nullable )initWithThreadID:(NSString* _Nonnull)threadID {
    self = [super init];
    if (self) {
        _publicID = threadID;
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
