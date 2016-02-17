//
//  WeatherDataHelper.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/1/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataHelper : NSObject

+ (WeatherDataHelper *)helper;

//根据天气类型获取图片
- (NSString *)getWeatherIconByCode:(NSString *)codeString isDay:(BOOL)isDay;

@end
