//
//  WeatherLocationHelper.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/2/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class WeatherLocationHelper;

@protocol WeatherLocationDelegate <NSObject>

- (void)weatherLocation:(WeatherLocationHelper *)helper didSuccess:(NSString *)cityName;
- (void)weatherLocation:(WeatherLocationHelper *)helper didFailed:(NSError *)error;
- (void)weatherLocationDidClose:(WeatherLocationHelper *)helper;

@end

@interface WeatherLocationHelper : NSObject

@property(nonatomic, weak)id<WeatherLocationDelegate>delegate;

@property(nonatomic, assign)BOOL isFirstTime;

+ (WeatherLocationHelper *)helper;

- (void)startLocation;

@end
