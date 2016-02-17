//
//  WeatherBasicInfoView.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherBasicInfoView : UIView

@property(nonatomic, strong)WeatherBasicInfoModel *model;

- (void)startAnimation;

@end
