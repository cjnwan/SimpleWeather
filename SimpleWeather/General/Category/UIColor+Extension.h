//
//  UIColor+Extension.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/6/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithRGB:(NSString *)color;

+ (UIColor *)colorWithRGB:(NSString *)color withAlpha:(CGFloat)alpha;

@end
