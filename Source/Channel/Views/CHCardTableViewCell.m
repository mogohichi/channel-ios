//
//  CHCardTableViewCell.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardTableViewCell.h"
#import "NSDate+Utilities.h"

@implementation CHCardTableViewCell

- (void)setupView:(CHMessage*)data{
    self.titleLabel.text = [NSString stringWithFormat:@"%@", data.sender.name];
    self.timeLabel.text = [data.createdAt shortTimeString];
}


- (void)setMessage:(CHMessage *)message{
    _message = message;
    [self setupView:message];
}


@end
