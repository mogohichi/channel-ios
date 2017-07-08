//
//  CHView.m
//  Channel
//
//  Created by Apisit Toompakdee on 2/6/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHView.h"

@implementation CHView

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
    self.layer.cornerRadius = self.cornerRadius;
    self.clipsToBounds = YES;
}

- (void)prepareForInterfaceBuilder{
    [self setupView];
}

@end
