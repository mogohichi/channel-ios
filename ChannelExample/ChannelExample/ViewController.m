//
//  ViewController.m
//  ChannelExample
//
//  Created by Apisit Toompakdee on 3/5/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "ViewController.h"
#import <Channel/Channel.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapContact:(id)sender {
        NSString* userID = @"AnyID";
        NSDictionary* userData = @{@"name":@"John",
                                   @"lastname": @"Doe"};
        UIViewController* vc = [Channel chatViewControllerWithUserID:userID userData:userData];
        vc.title = @"Your title here";
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
}

@end
