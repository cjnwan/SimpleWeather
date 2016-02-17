//
//  UIImage+Extension.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/12/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
