//
//  CHButtonListToolbar.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHButtonListToolbar.h"
#import "CHCardButton.h"
#import "CHBarButtonItem.h"
#import "NSString+Utilities.h"
#import "CHButton.h"
#import "CHUtilities.h"

@interface CHButtonListToolbar()

@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) NSMutableArray* actionButtons;
@property (nonatomic) NSInteger animateIndex;

@end

@implementation CHButtonListToolbar

- (void)addActionButtonWithAnimation:(CHButton*)button{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            button.alpha = 1;
        } completion:^(BOOL finished) {
            
            self.animateIndex++;
            if (self.animateIndex > self.actionButtons.count-1){
                self.animateIndex = 0;
                return;
            }
            CHButton* nextButton = [self.actionButtons objectAtIndex:self.animateIndex];
            if (nextButton == nil){
                return;
            }
            [self addActionButtonWithAnimation:nextButton];
            
        }];
    });
}

- (void)setButtons:(NSArray *)buttons{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.animateIndex = 0;
        self.actionButtons = [[NSMutableArray alloc]init];
        _buttons = buttons;
        
        __block NSInteger index = 1;
        __block CGFloat contentWidth = 0;
        
        if (self.scrollView != nil){
            [self.scrollView removeFromSuperview];
            self.scrollView = nil;
        }
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:self.scrollView];
        
        
        //only one button we make it full width and height
        if (buttons.count == 1){
            CHButton *button = [[CHButton alloc]initWithFrame:self.bounds];
            CHCardButton* cardButton = buttons.firstObject;
            [button setTitle:cardButton.title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            
            if (cardButton.backgroundColor != nil){
                [button setBackgroundColor:cardButton.backgroundColor];
            }else{
                [button setBackgroundColor:[CHUtilities colorWithHexString:@"0080FF"]];
            }
            
            if (cardButton.textColor != nil){
                [button setTitleColor:cardButton.textColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            button.clipsToBounds = YES;
            button.data = cardButton;
            button.alpha = 1;
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            self.scrollView.contentSize = self.bounds.size;
            [self.scrollView addSubview:button];
            return;
        }
        
        for (CHCardButton* cardButton in buttons){
            CGFloat textWidth = [cardButton.title textWidthWithFont:[UIFont systemFontOfSize:15]] + 20;
            CHButton *button = [[CHButton alloc]initWithFrame:CGRectMake(contentWidth + (10 * index), 10, textWidth, 40.0)];
            [button setTitle:cardButton.title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            
            if (cardButton.backgroundColor != nil){
                [button setBackgroundColor:cardButton.backgroundColor];
            }else{
                [button setBackgroundColor:[CHUtilities colorWithHexString:@"0080FF"]];
            }
            
            if (cardButton.textColor != nil){
                [button setTitleColor:cardButton.textColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            

            button.cornerRadius = 6.0;
            button.layer.cornerRadius = 6.0;
            button.clipsToBounds = YES;
            button.data = cardButton;
            button.alpha = 0;
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            contentWidth += textWidth;
            [self.scrollView addSubview:button];
            [self.actionButtons addObject:button];
            index++;
        }
        [self addActionButtonWithAnimation:[self.actionButtons objectAtIndex:self.animateIndex]];
        self.scrollView.contentSize = CGSizeMake(contentWidth + ((buttons.count + 1) * 10), self.bounds.size.height);
    });
}

- (void)commonInit{
    self.backgroundColor = [UIColor whiteColor];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

#pragma mark -
- (void)didTapButton:(CHButton*)sender{
    if ([self.toolbarDelegate respondsToSelector:@selector(buttonListToolbar:didTapButton:)]){
        [self.toolbarDelegate buttonListToolbar:self didTapButton:sender];
    }
}

@end
