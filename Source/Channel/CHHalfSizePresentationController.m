//
//  CHHalfSizePresentationController.m
//  Channel
//
//  Created by Apisit Toompakdee on 3/24/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHHalfSizePresentationController.h"


@interface CHHalfSizePresentationController()

@property (nonatomic) UIView* dimmingView;

@end

@implementation CHHalfSizePresentationController

- (void)setupDimming{
    self.dimmingView = [[UIView alloc]initWithFrame:self.presentingViewController.view.bounds];
    self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
    effectView.bounds = self.dimmingView.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   // [self.dimmingView addSubview:effectView];
}

-(void)presentationTransitionWillBegin{

    self.dimmingView.frame = self.presentedViewController.view.bounds;
    self.dimmingView.alpha = 0;
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 1;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

-(void)dismissalTransitionWillBegin{
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

-(void)containerViewWillLayoutSubviews{
    self.dimmingView.frame = self.containerView.bounds;
}

-(instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self){
        [self setupDimming];
    }
    return self;
}

-(CGRect)frameOfPresentedViewInContainerView{
    return CGRectMake(0, self.containerView.bounds.size.height/2, self.containerView.bounds.size.width, self.containerView.bounds.size.height/2);
}
@end
