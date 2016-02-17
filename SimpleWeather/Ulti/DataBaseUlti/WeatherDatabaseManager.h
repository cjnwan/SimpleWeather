//
//  WeatherDatabaseManager.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherDatabaseManager;

@interface WeatherDatabaseManager : NSObject

+ (WeatherDatabaseManager *)manager;

- (BOOL)DBWeatherInsertModel:(WeatherCacheModel *)model;

- (BOOL)DBWeatherIsExistModelByCityKey:(NSString *)cityKey;

- (BOOL)DBWeatherUpdateBean:(WeatherCacheModel *)model;

- (BOOL)DBWeatherDeleteModel:(NSString *)cityName;

- (WeatherCacheModel *)DBWeatherGetModelByCityName:(NSString *)cityName;

- (NSMutableArray *)DBWeatherGetAllCitys;

- (NSMutableArray *)DBWeatherGETAllModels;


@end
