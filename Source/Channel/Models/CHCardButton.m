//
//  CHCardButton.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardButton.h"
#import "CHUtilities.h"

@implementation CHCardButton

-(instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.title = json[@"title"];
        self.payload = json[@"payload"];
        self.type = json[@"type"];
        self.url = json[@"url"];
        
        NSString* backgroundColorString = json[@"backgroundColor"];
        if (backgroundColorString != nil){
            self.backgroundColor = [CHUtilities colorWithHexString:backgroundColorString];
        }
        
        NSString* textColorString = json[@"textColor"];
        if (textColorString != nil){
            self.textColor = [CHUtilities colorWithHexString:textColorString];
        }
    }
    return self;
}



@end
