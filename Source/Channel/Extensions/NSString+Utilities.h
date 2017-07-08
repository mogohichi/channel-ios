//
//  NSString+Utilities.h
//  
//
//  Created by Apisit Toompakdee on 7/7/14.
//  Copyright (c) 2014 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utilities)
- (NSString* _Nonnull)trim;
- (BOOL)isValidEmail;
- (NSDate* _Nullable)toNSDate;
- (CGFloat)textHeightWithMaxWidth:(CGFloat)width font:(UIFont* _Nonnull)font;
- (CGFloat)textWidthWithFont:(UIFont * _Nonnull)font;
@end
