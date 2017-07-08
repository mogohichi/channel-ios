//
//  CHTextView.m
//  Channel
//
//  Created by Apisit Toompakdee on 12/18/16.
//  Copyright © 2016 Mogohichi, Inc. All rights reserved.
//

#import "CHTextView.h"

@implementation CHTextView

- (void)setupView{
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsMake(10,6,10,6);
    self.contentInset = UIEdgeInsetsZero;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
    self.layer.borderWidth = 1.0;
    self.clipsToBounds = YES;
}

-(void)prepareForInterfaceBuilder{
    [self setupView];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setupView];
    return self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]){
        [self.textViewDelegate textViewDidBeginEditing:self];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([self.textViewDelegate respondsToSelector:@selector(textView:didType:)]){
        [self.textViewDelegate textView:self didType:textView.text];
    }
}

@end
