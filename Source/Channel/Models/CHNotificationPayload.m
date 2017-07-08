//
//  CHNotificationPayload.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/16/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHNotificationPayload.h"
#import "CHNotificationButton.h"

@implementation CHNotificationPayload

- (instancetype)initWithJSON:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.text = json[@"text"];
        self.templateType = json[@"templateType"];
        if (json[@"imageURL"] != nil) {
            self.imageURL = [NSURL URLWithString:json[@"imageURL"]];
        }
        
        NSArray* buttons = json[@"buttons"];
        if ([self.templateType isEqualToString:@"IMAGE_TEXT_ONE_BUTTON"]) {
            NSMutableArray* buttonsList = [[NSMutableArray alloc]init];
            CHNotificationButton* button = [[CHNotificationButton alloc]initWithJSON:buttons[0]];
            [buttonsList addObject:button];
            self.buttons = [NSArray arrayWithArray:buttonsList];
        } else {
            NSMutableArray* buttonsList = [[NSMutableArray alloc]init];
            for (NSDictionary* dic in buttons){
                NSString* title = dic[@"title"];
                if (title != nil && [title isEqualToString:@""] == false) {
                    CHNotificationButton* button = [[CHNotificationButton alloc]initWithJSON:dic];
                    [buttonsList addObject:button];
                }
            }
            self.buttons = [NSArray arrayWithArray:buttonsList];
        }
        
        
    }
    return self;
}

@end
