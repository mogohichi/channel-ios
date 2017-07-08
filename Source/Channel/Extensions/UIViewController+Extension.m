//
//  UIViewController+Extension.m
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)presentViewControllerFromVisibleViewController:(UIViewController *)viewControllerToPresent
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)self;
        [navController.topViewController presentViewControllerFromVisibleViewController:viewControllerToPresent];
    } else if (self.presentedViewController) {
        [self.presentedViewController presentViewControllerFromVisibleViewController:viewControllerToPresent];
    } else {
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
    }
}
@end
