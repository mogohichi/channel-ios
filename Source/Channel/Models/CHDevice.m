//
//  CHDevice.m
//  Channel
//
//  Created by Apisit Toompakdee on 2/6/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHDevice.h"
#import "SystemServices.h"

@implementation CHDevice

+(NSDictionary*)info{
   SystemServices* service = [[SystemServices alloc]init];
    return service.allSystemInformation;
}

@end
