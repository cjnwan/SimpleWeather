//
//  WeatherDataHelper.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/1/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherDataHelper.h"


@interface WeatherDataHelper()


@end

@implementation WeatherDataHelper

+ (WeatherDataHelper *)helper{
    static WeatherDataHelper *dataHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHelper = [[WeatherDataHelper alloc]init];
    });
    return dataHelper;
}


- (NSString *)getWeatherIconByCode:(NSString *)codeString isDay:(BOOL)isDay{
    NSString *iconName = @"";
    NSInteger code = [codeString integerValue];
    switch (code) {
            
        case 100:
            iconName = isDay?@"clear_day":@"clear_night";
            break;
        case 101:
            iconName = @"mostly_cloudy_day_night";
            break;
        case 102:
            iconName = isDay?@"partly_cloudy_day":@"partly_cloudy_night";
            break;
        case 103:
            iconName = isDay?@"fair_day":@"fair_night";
            break;
        case 104:
            iconName = @"cloudy_day_night";
            break;
        case 200:
        case 201:
        case 202:
        case 203:
        case 204:
        case 205:
        case 206:
        case 207:
        case 208:
        case 209:
        case 210:
            iconName = @"windy_day_night";
            break;
        case 211:
            iconName = @"hurricane_day_night";
            break;
        case 212:
        case 213:
            iconName = @"tornado_day_night";
            break;
        case 300:
        case 301:
            iconName = @"scattered_showers_day_night";
            break;
        case 302:
        case 303:
            iconName = @"thundershowers_day_night";
            break;
        case 304:
            iconName = @"hail_day_night";
            break;
        case 305:
        case 309:
            iconName = @"light_rain_day_night";
        case 306:
            iconName = @"scattered_showers_day_night";
            break;
        case 307:
        case 308:
        case 310:
        case 311:
        case 312:
            iconName = @"rain_day-night";
            break;
        case 313:
            iconName = @"freezing_rain_day_night";
            break;
        case 400:
            iconName = @"flurries_day_night";
            break;
        case 401:
            iconName = @"snow_day_night";
            break;
        case 402:
        case 403:
        case 407:
            iconName = @"heavy_snow_day_night";
            break;
        case 404:
            iconName = @"snow_rain_mix_day_night";
            break;
        case 405:
        case 406:
            iconName = @"sleet_mix_day_night";
            break;
        case 500:
        case 501:
            iconName = @"fog_day_night";
            break;
        case 502:
            iconName = @"haze_day_night";
            break;
        case 503:
        case 504:
            iconName = @"dust_day_night";
            break;
        case 505:
        case 506:
        case 507:
            iconName = @"smoky_day_night";
            break;
        case 900:
        case 901:
        case 999:
            iconName = @"na";
            break;
        default:
            iconName = @"na";
            break;
    }
    return iconName;
}

- (NSDictionary *)getWeatherCodeDic{
    static NSDictionary *weatherCodeDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherCodeDic = @{
                           @"100":@"晴",
                           @"101":@"多云",
                           @"102":@"少云",
                           @"103":@"晴转多云",
                           @"104":@"阴",
                           @"200":@"有风",
                           @"201":@"平静",
                           @"202":@"微风",
                           @"203":@"和风",
                           @"204":@"清风",
                           @"205":@"强风",
                           @"206":@"疾风",
                           @"207":@"大风",
                           @"208":@"烈风",
                           @"209":@"风暴",
                           @"210":@"狂暴风",
                           @"211":@"飓风",
                           @"212":@"龙卷风",
                           @"213":@"热带风暴",
                           @"300":@"阵雨",
                           @"301":@"强阵雨",
                           @"302":@"雷阵雨",
                           @"303":@"强雷阵雨",
                           @"304":@"雷阵雨伴有冰雹",
                           @"305":@"小雨",
                           @"306":@"中雨",
                           @"307":@"大雨",
                           @"308":@"极端降雨",
                           @"309":@"细雨",
                           @"310":@"暴雨",
                           @"311":@"大暴雨",
                           @"312":@"特大暴雨",
                           @"313":@"冻雨",
                           @"400":@"小雪",
                           @"401":@"中雪",
                           @"402":@"大雪",
                           @"403":@"暴雪",
                           @"404":@"雨夹雪",
                           @"405":@"雨雪天气",
                           @"406":@"阵雨夹雪",
                           @"407":@"阵雪",
                           @"500":@"薄雾",
                           @"501":@"雾",
                           @"502":@"霾",
                           @"503":@"扬沙",
                           @"504":@"浮尘",
                           @"506":@"火山灰",
                           @"507":@"沙尘暴",
                           @"508":@"强沙尘暴",
                           @"900":@"热",
                           @"901":@"冷",
                           @"999":@"未知"
                           };
    });
    return weatherCodeDic;
}

@end
