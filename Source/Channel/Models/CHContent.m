//
//  CHContent.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHContent.h"
#import "CHCard.h"
#import "CHCardButton.h"

@implementation CHContent

- (instancetype)initWithText:(NSString*)text;
{
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (instancetype)initWithText:(NSString*)text postbackPayload:(NSString*)payload;
{
    self = [super init];
    if (self) {
        self.text = text;
        self.postback = [[CHPostback alloc]initWithPayload:payload];
    }
    return self;
}


-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        if (json[@"text"] != nil) {
            self.text = json[@"text"];
        }
        
        if (json[@"topic"] != nil) {
            self.topic = [[CHTopic alloc]init];
            self.topic.name = json[@"topic"];
        }
        
        if (json[@"card"] != nil) {
            NSDictionary* cardObject = json[@"card"];
            self.card = [[CHCard alloc]initWithJSON:cardObject];
        }
        
        if (json[@"buttons"] != nil){
            NSArray* buttons = json[@"buttons"];
            NSMutableArray* list = [NSMutableArray new];
            for (NSDictionary* json in buttons){
                CHCardButton* button =[[CHCardButton alloc]initWithJSON:json];
                [list addObject:button];
            }
            self.buttons = list;
        }
        
    }
    return self;
}

-(instancetype)initWithCard:(CHCard *)card{
    self = [super init];
    if (self) {
        self.card = card;
    }
    return self;
}


- (NSDictionary*)toJSON{
    NSMutableDictionary* json = [[NSMutableDictionary alloc]init];
    if (self.text != nil){
        json[@"text"] = self.text;
    }
    
    if (self.postback != nil) {
        json[@"postback"] = [self.postback toJSON];
    }
    
    if (self.card != nil) {
        json[@"card"] = [self.card toJSON];
    }
    
    return json;
}

@end
