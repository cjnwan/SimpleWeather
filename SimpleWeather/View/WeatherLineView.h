//
//  WeatherLineView.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/6/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherLineView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTrendModels:(NSMutableArray *)trendModel;

- (void)startMaskAnimation;

- (void)startTopLineAnimation;

- (void)startBottomAnimation;
@end
