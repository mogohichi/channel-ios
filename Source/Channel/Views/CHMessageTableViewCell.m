//
//  CHMessageTableViewCell.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHMessageTableViewCell.h"
#import "NSDate+Utilities.h"
#import "CHUtilities.h"

@interface CHMessageTableViewCell()

@end

@implementation CHMessageTableViewCell

- (void)setupView:(CHMessage*)data{
    
    self.messageLabel.text = data.content.text;
    self.messageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", data.sender.name];
    
    self.timeLabel.text = [data.createdAt shortTimeString];
    self.messageLabel.userInteractionEnabled = YES;
}


- (void)setMessage:(CHMessage *)message {
    _message = message;
    [self setupView:message];
}


- (void)setupSettings:(CHApplication*)application {
    NSString* backgroundColor = application.settings.publicChat[_message.isFromBusiness == true ? @"textBackgroundColor1" : @"textBackgroundColor2"];
    NSString* textColor = application.settings.publicChat[_message.isFromBusiness == true ? @"textColor1" : @"textColor2"];
    self.messageLabel.backgroundColor = [CHUtilities colorWithHexString:backgroundColor];
    self.messageLabel.textColor = [CHUtilities colorWithHexString:textColor];
}

- (void)setApplication:(CHApplication *)application {
    _application = application;
    [self setupSettings:application];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.profileImageView.image = nil;
}

@end
