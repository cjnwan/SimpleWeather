//
//  WeatherDataModel.m
//  SimpleWeather
//
//  Created by 陈剑南 on 12/31/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import "WeatherDataModel.h"


@implementation WeatherDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"daily_forecast" : [WeatherDailyModel class]
             };
}
@end

@implementation WeatherBasicModel

@end

@implementation WeatherDailyModel

@end

@implementation WeatherAstroModel

@end

@implementation WeatherTempModel

@end

@implementation WeatherNowModel

@end

@implementation WeatherCondModel


@end

@implementation WeatherWindModel


@end

@implementation WeatherDailyCondModel

@end

@implementation WeatherBasicInfoModel

@end

@implementation WeatherDailyForcastModel

- (instancetype)init{
    if(self = [super init]){
        self.dailyForcast =[NSMutableArray array];
    }
    return self;
}

@end

@implementation WeatherTempTrendModel

@end

@implementation WeatherCityModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self.code =  [aDecoder decodeObjectForKey:@"code"];
    self.tmp =  [aDecoder decodeObjectForKey:@"tmp"];
    self.address =  [aDecoder decodeObjectForKey:@"address"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.tmp forKey:@"tmp"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

@end

@implementation WeatherCacheModel

@end

