//
//  CHCardTypeImageTableViewCell.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardTypeImageTableViewCell.h"
#import "CHCardPayloadImage.h"
#import "UIImage+Utilities.h"


@interface CHCardTypeImageTableViewCell()

@end

@implementation CHCardTypeImageTableViewCell

-(void)setMessage:(CHMessage *)message{
    [super setMessage:message];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.payloadImageView.image = nil;
}

- (IBAction)didTapImageView:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cardTypeImageTableViewCell:imageView:message:)]) {
        [self.delegate cardTypeImageTableViewCell:self imageView:self.payloadImageView message:self.message];
    }
}


@end
