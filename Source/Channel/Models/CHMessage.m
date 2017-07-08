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
        self.isFromBusiness = [json[@"isFromBusiness"] boolValue];
        self.createdAt =  [dateString toNSDate];
        self.content = [[CHContent alloc]initWithJSON:json[@"data"]];
        self.sender = [[CHSender alloc]initWithJSON:json[@"sender"]];
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

@end
