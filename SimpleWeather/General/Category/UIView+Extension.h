//
//  UIView+Extension.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/1/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - UIView Property

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, readonly)UIViewController *viewController; //获取当前视图的Controller

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer;

- (void)applyAnimationGroup:(CAAnimationGroup *)groupAnimation toLayer:(CALayer *)layer;

@end
