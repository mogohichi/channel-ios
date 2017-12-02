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

- (instancetype)initWithText:(NSString*)text;
{
    self = [super init];
    if (self) {
        self.clientObjectID = [[NSUUID UUID] UUIDString];
        self.content = [[CHContent alloc]initWithText:text];
    }
    return self;
}
- (instancetype)initWithImageURL:(NSURL*)imageURL{
    self = [super init];
    if (self) {
        self.clientObjectID = [[NSUUID UUID] UUIDString];
        CHCard* card = [[CHCard alloc]init];
        card.type = CardTypeImage;
        card.payload = [[CHCardPayloadImage alloc]initWithImageURL:imageURL];
        self.content = [[CHContent alloc]initWithCard:card];
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
        self.clientObjectID = [[NSUUID UUID] UUIDString];
        self.content = [[CHContent alloc]initWithText:text postbackPayload:payload];
    }
    return self;
}

- (NSDictionary*)toJSON{
    
    if (self.content.card !=nil){
        return @{@"card":[self.content.card toJSON]};
    }
    
    NSMutableDictionary* json = [[NSMutableDictionary alloc]init];
    if (self.content.text != nil){
        json[@"text"] = self.content.text;
    }
    
    if (self.content.postback != nil) {
        json[@"postback"] = [self.content.postback toJSON];
    }
    
    return json;
}

- (NSData*)toData {
    NSMutableDictionary* json = [[NSMutableDictionary alloc]init];
    if (self.sender != nil){
        json[@"sender"] = [self.sender toJSON];
    }
    
    if (self.content != nil) {
        json[@"data"] = [self.content toJSON];
    }
    
    
    if (self.createdAt != nil) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        json[@"createdAt"] = [dateFormatter stringFromDate:self.createdAt];
    }
    
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&dataError];
    
    return postData;
}

@end
