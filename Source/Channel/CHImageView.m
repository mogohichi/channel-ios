//
//  CHImageView.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHImageView.h"
#import "CHUtilities.h"


@implementation CHImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.layer.cornerRadius = 6.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [CHUtilities colorWithHexString:@"cccccc"].CGColor;
    self.clipsToBounds = YES;
}

- (void)prepareForInterfaceBuilder{
    [self setupView];
}

@end
