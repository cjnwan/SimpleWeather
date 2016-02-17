//
//  WeatherDailyForcastView.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDailyForcastView : UIView

@property(nonatomic, strong)WeatherDailyForcastModel *model;

-(void)startAnimation:(CGFloat)from to:(CGFloat)to;

-(void)completeAnimation;

@end
