//
//  NSString+Utilities.m
//  
//
//  Created by Apisit Toompakdee on 7/7/14.
//  Copyright (c) 2014 Mogohichi, Inc. All rights reserved.
//

#import "NSString+Utilities.h"
#import "NSAttributedString+Category.h"

@implementation NSString (Utilities)
- (NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGFloat)textWidthWithFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] size].width;
}

- (BOOL)isValidEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (CGFloat)textHeightWithMaxWidth:(CGFloat)width font:(UIFont*)font{
    NSString* itemText = self;
    NSDictionary *attribs = @{};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
    NSRange regularTextRange = [itemText rangeOfString:self];
    [attributedText setAttributes:@{NSFontAttributeName:font} range:regularTextRange];
    CGRect textSize = [attributedText boundsForWidth:width];
   return textSize.size.height;
}

- (NSDate* _Nullable)toNSDate{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    return [dateFormatter dateFromString:self];
}

@end
