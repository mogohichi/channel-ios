//
//  UITextView+Extensions.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "UITextView+Extensions.h"

@implementation UITextView (Extensions)

- (void)clearText{
    self.attributedText = nil;
    
    if (self.undoManager != nil){
        [self.undoManager removeAllActions];
    }
}

@end
