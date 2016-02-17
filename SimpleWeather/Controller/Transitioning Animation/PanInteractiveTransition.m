//
//  ModalDismissAnimation.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/10/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "PanInteractiveTransition.h"

@interface PanInteractiveTransition()

@property(nonatomic, strong)UIViewController *presentedVC;

@end

@implementation PanInteractiveTransition


- (void)panToDismis:(UIViewController *)viewController{
    self.presentedVC = viewController;
    UIPanGestureRecognizer *panGstR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.presentedVC.view addGestureRecognizer:panGstR];
}

-(void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.presentedVC.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interacting = YES;
            [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:{
            //1
            CGFloat percent = (translation.y/GlobalScreenHeight/2) <= 1 ? (translation.y/GlobalScreenHeight/2):1;
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //2
            self.interacting = NO;
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}
@end
