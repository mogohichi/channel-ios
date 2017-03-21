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
    [Channel checkNewMessages:^(NSInteger numberOfNewMessages) {
        if (numberOfNewMessages > 0){
            NSString* title = [NSString stringWithFormat:@"You have new %ld messages",(long)numberOfNewMessages];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* view = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openChatView];
            }];
            [alert addAction:view];
        
            UIAlertAction* later = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:later];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openChatView{
    NSString* userID = @"TestID";
    NSDictionary* userData = @{@"name":@"John",
                               @"lastname": @"Doe"};
    UIViewController* vc = [Channel chatViewControllerWithUserID:userID userData:userData];
    vc.title = @"Your title here";
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

}

- (IBAction)didTapContact:(id)sender {
    [self openChatView];
}

@end
