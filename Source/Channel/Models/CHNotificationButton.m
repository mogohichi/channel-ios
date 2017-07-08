//
//  CHNotificationButton.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHNotificationButton.h"

@interface CHNotificationButton()

@property (nonatomic) NSDictionary* json;

@end

@implementation CHNotificationButton

- (instancetype)initWithTitle:(NSString*)title payload:(NSString*)payload
{
    self = [super init];
    if (self) {
        self.title = title;
        self.payload = payload;
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.json = json;
        self.title = json[@"title"];
        self.payload = json[@"payload"];
        self.type = json[@"type"];
        self.backgroundColor = json[@"backgroundColor"];
        self.textColor = json[@"textColor"];
        
        if (json[@"url"] != nil){
            self.URL = [NSURL URLWithString:json[@"url"]];
        }
    }
    return self;
}

-(NSDictionary *)toJSON{
    return self.json;
}
@end
