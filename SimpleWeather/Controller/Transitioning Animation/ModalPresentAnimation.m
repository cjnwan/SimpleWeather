//
//  ModalPresentAnimation.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "ModalPresentAnimation.h"

@implementation ModalPresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalRect = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalRect, 0, [[UIScreen mainScreen]bounds].size.height);
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = finalRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
