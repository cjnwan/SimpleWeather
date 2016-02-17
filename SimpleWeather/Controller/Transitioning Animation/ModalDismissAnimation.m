//
//  ModalDIsmissAnimation.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/10/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "ModalDismissAnimation.h"

@implementation ModalDismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initRect  = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalRect = CGRectOffset(initRect, 0, [[UIScreen mainScreen]bounds].size.height);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.frame = finalRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
