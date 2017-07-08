//
//  CHInputBar.m
//  Channel
//
//  Created by Apisit Toompakdee on 1/7/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHInputBar.h"
#import "UITextView+Extensions.h"

@implementation CHInputBar


- (void)commonInit{
    self.textView = [[CHTextView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.7, self.bounds.size.height - 10)];
    self.textView.textViewDelegate = self;
    
    self.backgroundColor = [UIColor whiteColor];
    self.barTintColor = [UIColor whiteColor];
    self.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem* textFieldItem = [[UIBarButtonItem alloc]initWithCustomView:self.textView];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.mogohichi.Channel"];
    UIImage* sendImage = [UIImage imageNamed:@"send" inBundle:bundle compatibleWithTraitCollection:nil];
    self.rightButton = [[UIBarButtonItem alloc]initWithImage:sendImage style:UIBarButtonItemStyleDone target:self action:@selector(didTapRight:)];
    self.leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapLeft:)];
    
    self.rightButton.enabled = false;
    
    self.items = @[self.leftButton,flexSpace, textFieldItem,flexSpace, self.rightButton];
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
- (void)clearCachedText{

}


#pragma mark -
- (void)didTapLeft:(id)sender{
    if ([self.inputBarDelegate respondsToSelector:@selector(inputBar:didTapLeftButton:)]){
        [self.textView resignFirstResponder];
        [self.inputBarDelegate inputBar:self didTapLeftButton:sender];
    }
}

- (void)didTapRight:(id)sender{
    
    NSString* textTrimmed = [self.textView.text copy];
    if ([self.inputBarDelegate respondsToSelector:@selector(inputBar:didTapSend:)]){
        self.rightButton.enabled = false;
        [self.textView clearText];
        [self clearCachedText];
        CHMessage* message = [[CHMessage alloc]initWithText:textTrimmed];
        message.isFromClient = YES;
        [self.inputBarDelegate inputBar:self didTapSend:message];
    }
}

#pragma mark - 
-(void)textView:(id)textView didType:(NSString *)text{
    self.rightButton.enabled = text.length > 0;
    
    if ([self.inputBarDelegate respondsToSelector:@selector(inputBar:didStartTyping:)]){
        [self.inputBarDelegate inputBar:self didStartTyping:nil];
    }
}

-(void)textViewDidBeginEditing:(id)textView{
    if ([self.inputBarDelegate respondsToSelector:@selector(inputBar:didBegineEditing:)]){
        [self.inputBarDelegate inputBar:self didBegineEditing:nil];
    }
}
- (void)resignTextViewResponder{
    [self.textView resignFirstResponder];
}

@end
