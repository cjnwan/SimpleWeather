//
//  WeatherBounceView.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/6/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WeatherBounceView : UIView

-(void)startAnimation:(CGFloat)from to:(CGFloat)to;

-(void)completeAnimation;

@end
