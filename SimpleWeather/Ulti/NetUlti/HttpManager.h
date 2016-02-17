//
//  HttpManager.h
//  SimpleWeather
//
//  Created by 陈剑南 on 12/31/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpManager : NSObject

+ (HttpManager *)manager;

- (void)getWeatherDataByCityName:(NSString *)cityName dataHandle:(void (^)(WeatherDataModel * _Nonnull dataModel))dataHandle;

- (void)getWeatherDataByCityNames:(NSArray *)cityNames dataHandle:(void (^)(NSArray * _Nonnull dataModels))dataHandle;

@end
