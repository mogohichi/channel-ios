//
//  CHCard.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCard.h"
#import "CHCardPayloadImage.h"
#import "CHCardPayloadTemplate.h"

@implementation CHCard

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSString* type = json[@"type"];
        self.type = type;
        
        if ([self.type isEqualToString:CardTypeImage]){
            self.payload = [[CHCardPayloadImage alloc]initWithJSON:json[@"payload"]];
        }else if ([self.type isEqualToString:CardTypeTemplate]){
            self.payload = [[CHCardPayloadTemplate alloc]initWithJSON:json[@"payload"]];
        }
        
        self.widthRatio = json[@"widthRatio"];
        self.heightRatio = json[@"heightRatio"];
    }
    return self;
}

-(NSDictionary *)toJSON{
    
    NSMutableDictionary* json = [[NSMutableDictionary alloc]initWithDictionary:@{@"type": self.type}];
    if ([self.payload toJSON] != nil){
        [json setValue:[self.payload toJSON] forKey:@"payload"];
    }
    return json;
}

@end
