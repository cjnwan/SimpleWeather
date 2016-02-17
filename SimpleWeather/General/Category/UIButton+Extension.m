//
//  UIButton+Extension.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/4/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)horizontalCenterTitlesAndImages:(CGFloat)spacing{
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

@end
