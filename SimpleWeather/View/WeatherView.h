//
//  WeatherView.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherMenuDelegate <NSObject>

- (void)menuViewDidClick;

@end

@interface WeatherView : UIView

@property(nonatomic, strong)id<WeatherMenuDelegate>delegate;

@property(nonatomic, strong)WeatherDataModel *model;

- (void)startAnimation;

@end
