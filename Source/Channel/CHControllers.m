//
//  CHControllers.m
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import "CHControllers.h"

@implementation CHControllers

+ (NSBundle*)bundle{
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
    return bundle;
}

+(CHTableViewController *)channelViewController{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[CHControllers bundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"CHTableViewController"];
}

@end
