//
//  CHWebViewViewController.m
//  Channel
//
//  Created by Apisit Toompakdee on 2/26/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHWebViewViewController.h"

@interface CHWebViewViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CHWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.title = self.url.absoluteString;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapLeft:)];
}
- (IBAction)didTapAction:(id)sender {
    
    
    UIActivityViewController* activityViewControntroller = [[UIActivityViewController alloc]initWithActivityItems:@[self.url] applicationActivities:nil];
      activityViewControntroller.excludedActivityTypes = @[];
    [self presentViewController:activityViewControntroller animated:YES completion:nil];
}


- (IBAction)didTapLeft:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
