//
//  ModalDismissAnimation.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/10/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void)panToDismis:(UIViewController *)viewController;

@end
