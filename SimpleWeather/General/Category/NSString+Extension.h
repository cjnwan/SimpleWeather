//
//  NSString+Extension.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/2/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)widthForFont:(UIFont *)font;


- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


@end
