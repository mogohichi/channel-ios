//
//  NSAttributedString+Category.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/9/15.
//  Copyright (c) 2015 Mogohichi, Inc. All rights reserved.
//

#import "NSAttributedString+Category.h"
#import <CoreText/CoreText.h>
@implementation NSAttributedString (Category)

- (CGRect)boundsForWidth:(float)width
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    
    CGSize maxSize = CGSizeMake(width, 0);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, maxSize, nil);
    
    CFRelease(framesetter);
    
    return CGRectMake(0, 0, ceilf(size.width), ceilf(size.height));
}


@end
