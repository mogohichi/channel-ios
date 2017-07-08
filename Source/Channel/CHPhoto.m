//
//  CHPhoto.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/16/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHPhoto.h"

@implementation CHPhoto

@synthesize imageData;
@synthesize attributedCaptionTitle;
@synthesize attributedCaptionSummary;
@synthesize attributedCaptionCredit;
@synthesize placeholderImage;


-(instancetype)initWithImage:(UIImage *)image{

    self = [super init];
    self = [super init];
    if (self) {
        self.image = image;
    }

    return self;
}
@end
