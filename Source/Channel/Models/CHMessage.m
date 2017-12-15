//
//  CHMessage.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHMessage.h"
#import "NSString+Utilities.h"
#import "CHCardPayloadImage.h"
#import "CHCardButton.h"
@implementation CHMessage
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (instancetype)initWithText:(NSString*)text;
{
    self = [super init];
    if (self) {
        self.localStorageObjectID = [[NSUUID UUID] UUIDString];
        self.content = [[CHContent alloc]initWithText:text];
        self.data = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text sender:(CHSender*)sender {
    self = [super init];
    if (self) {
        self.localStorageObjectID = [[NSUUID UUID] UUIDString];
        self.content = [[CHContent alloc]initWithText:text];
        self.sender = sender;
        self.data = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (instancetype)initWithImageURL:(NSURL*)imageURL{
    self = [super init];
    if (self) {
        self.localStorageObjectID = [[NSUUID UUID] UUIDString];
        CHCard* card = [[CHCard alloc]init];
        card.type = CardTypeImage;
        card.payload = [[CHCardPayloadImage alloc]initWithImageURL:imageURL];
        self.content = [[CHContent alloc]initWithCard:card];
        self.data = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        
        
        NSString* dateString = json[@"createdAt"];
        if (dateString != nil) {
            self.createdAt =  [dateString toNSDate];
        }
        
        if (json[@"id"] != nil) {
            self.publicID = json[@"id"];
        }
        
        if (json[@"isFromBusiness"] != nil) {
            self.isFromBusiness = [json[@"isFromBusiness"] boolValue];
        }
        
        if (json[@"data"] != nil && ![json[@"data"] isEqual:(id)[NSNull null]]) {
            self.content = [[CHContent alloc]initWithJSON:json[@"data"]];
            if (json[@"data"][@"localStorageObjectID"] != nil) {
                self.localStorageObjectID = json[@"data"][@"localStorageObjectID"];
            }
            self.data = [[NSMutableDictionary alloc]initWithDictionary:json[@"data"]];
        }
        if (json[@"sender"] != nil && ![json[@"sender"] isEqual:(id)[NSNull null]]) {
            self.sender = [[CHSender alloc]initWithJSON:json[@"sender"]];
        }
        
    }
    return self;
}


- (instancetype)initWithText:(NSString*)text postbackPayload:(NSString*)payload{
    self = [super init];
    if (self) {
        self.localStorageObjectID = [[NSUUID UUID] UUIDString];
        self.content = [[CHContent alloc]initWithText:text postbackPayload:payload];
    }
    return self;
}

- (NSDictionary*)toJSON{
    NSLog(@"%@",self.data.description);
    if (self.content.card !=nil){
        return @{@"card":[self.content.card toJSON]};
    }
    
    
    if (self.data == nil) {
        self.data = [[NSMutableDictionary alloc]init];
    }
    
    if (self.content.text != nil){
        self.data[@"text"] = self.content.text;
    }
    
    if (self.localStorageObjectID != nil){
        self.data[@"localStorageObjectID"] = self.localStorageObjectID;
    }
    
    if (self.content.postback != nil) {
        self.data[@"postback"] = [self.content.postback toJSON];
    }
    NSLog(@"%@",self.data.description);
    return self.data;
}

- (NSData*)toData {
    NSError* dataError = nil;
    NSMutableDictionary* wrapper = [[NSMutableDictionary alloc]init];
    wrapper[@"data"] = self.toJSON;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:wrapper options:0 error:&dataError];
    return postData;
}

@end
