//
//  CHMessageLabel.m
//  Channel
//
//  Created by Apisit Toompakdee on 2/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHMessageLabel.h"


@interface CHMessageLabel()

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation CHMessageLabel


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

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setupView{
    self.edgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
    
    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)prepareForInterfaceBuilder{
    [self setupView];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

- (void) copy: (id) sender
{
    [UIPasteboard generalPasteboard].string = self.text;
}

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    return (action == @selector(copy:));
}

- (void) handleLongPress: (UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}


@end
