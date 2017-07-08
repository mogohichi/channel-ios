//
//  CHNotificationViewController.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHNotificationViewController.h"
#import "Channel.h"
#import "CHButton.h"
#import "UIImage+Utilities.h"
#import "CHClient.h"
#import "CHUtilities.h"

@interface CHNotificationViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet CHButton *leftButton;
@property (strong, nonatomic) IBOutlet CHButton *rightButton;
@property (strong, nonatomic) IBOutlet CHButton *oneButton;
@property (strong, nonatomic) IBOutlet UIView *oneButtonContainer;
@property (strong, nonatomic) IBOutlet UIView *twoButtonsContainer;

@end

@implementation CHNotificationViewController

- (void)setupView{
    
    self.titleLabel.text = self.notification.payload.text;
    if (self.notification.payload.imageURL == nil){
        NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
        UIImage *patternImage = [UIImage imageNamed:@"notification-background-pattern" inBundle:bundle compatibleWithTraitCollection:nil];
        self.headerImageView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage* cachedImage = [UIImage imageFromCacheDirectory:self.notification.payload.imageURL.absoluteString.lastPathComponent];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cachedImage != nil){
                    self.headerImageView.image = cachedImage;
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData* data;
                        if ([self.notification.payload.imageURL.absoluteString hasPrefix:@"http"]){
                            data = [NSData dataWithContentsOfURL:self.notification.payload.imageURL];
                        }else{
                            data = [NSData dataWithContentsOfFile:self.notification.payload.imageURL.absoluteString];
                        }
                        if (data != nil){
                            UIImage* image = [UIImage imageWithData:data];
                            [image saveToCacheDirectory:self.notification.payload.imageURL.absoluteString.lastPathComponent];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.headerImageView.image = image;
                                self.headerImageView.clipsToBounds = YES;
                            });
                        }
                    });
                }
            });
        });
    };
    
    self.oneButtonContainer.hidden = true;
    self.twoButtonsContainer.hidden = true;
    
    if (self.notification.payload.buttons.count == 1) {
        self.oneButtonContainer.hidden = false;
        
        CHNotificationButton* oneNotificationButton = self.notification.payload.buttons[0];
        [self updateButton:self.oneButton notificationButton:oneNotificationButton tag:0
         ];
        
    }
    if (self.notification.payload.buttons.count == 2) {
        self.twoButtonsContainer.hidden = false;
        CHNotificationButton* leftNotificationButton = self.notification.payload.buttons[0];
        [self updateButton:self.leftButton notificationButton:leftNotificationButton tag:0
         ];
        
        CHNotificationButton* rightNotificationButton = self.notification.payload.buttons[1];
       [self updateButton:self.rightButton notificationButton:rightNotificationButton tag:1
        ];
    }
}

- (void)updateButton:(CHButton*)button notificationButton:(CHNotificationButton*)notificationButton tag:(NSInteger)tag {
    
    button.tag = tag;
    [button setTitle:notificationButton.title forState:UIControlStateNormal];
    
    if (notificationButton.backgroundColor != nil) {
        button.backgroundColor = [CHUtilities colorWithHexString:notificationButton.backgroundColor];
    }
    
    if (notificationButton.textColor != nil) {
        [button setTitleColor:[CHUtilities colorWithHexString:notificationButton.textColor] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 6.0;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didTapAction:(CHButton*)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        CHNotificationButton* button = self.notification.payload.buttons[sender.tag];
        
        if (button.URL != nil && [button.URL.absoluteString hasPrefix:@"http"]) {
            [[CHClient currentClient] presentWebViewWithURL:button.URL inViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        }
        
        [[CHClient currentClient] postbackNotification:self.notification button:button];
        if ([[Channel shared].delegate respondsToSelector:@selector(channelUserDidTapButtonNotificationView:button:)]){
            
            [[Channel shared].delegate channelUserDidTapButtonNotificationView:self.notification button:button];
        }
    }];
    
}


@end
