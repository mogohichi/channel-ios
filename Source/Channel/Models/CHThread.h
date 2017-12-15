//
//  CHThread.h
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHBase.h"

@class CHMessage;

@protocol CHThreadDelegate <NSObject>

- (void)didAddMessage:(CHMessage* _Nonnull)message;

@end

@interface CHThread : CHBase

@property (nonatomic, nonnull) NSMutableArray<CHMessage*> *messages;
@property (nonatomic, nullable) id<CHThreadDelegate> delegate;
@property (nonatomic, nullable) NSString* nextMessagesURL;

//Added November 30 2017
@property (nonatomic, nullable, readonly) NSString* publicID;
@property (nonatomic, nullable, readonly) NSString* threadOwnerClientID;
@property (nonatomic, nullable, readonly) NSMutableDictionary* data;
//end

- (instancetype _Nullable )initWithJSON:(NSDictionary*_Nullable)json;
- (instancetype _Nullable )initWithThreadID:(NSString* _Nonnull)threadID;

- (void)addText:(NSString* _Nonnull)text;
- (void)addMessage:(CHMessage* _Nonnull)message;

@end
