//
//  WeatherDataModel.h
//  SimpleWeather
//
//  Created by 陈剑南 on 12/31/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherBasicModel;
@class WeatherCondModel;
@class WeatherWindModel;
@class WeatherAstroModel;
@class WeatherTempModel;
@class WeatherDailyModel;
@class WeatherNowModel;
@class WeatherDailyCondModel;

@interface WeatherDataModel : NSObject

@property(nonatomic, strong)WeatherBasicModel *basic;
@property(nonatomic, strong)WeatherNowModel *now;
@property(nonatomic, strong)NSMutableArray *daily_forecast;

@end

@interface WeatherBasicModel : NSObject                 //基本信息

@property(nonatomic, copy)NSString *city;               //城市名称
@property(nonatomic, copy)NSString *cnty;               //国家
@property(nonatomic, copy)NSString *lat;                //纬度
@property(nonatomic, copy)NSString *lon;                //经度

@end

@interface WeatherNowModel : NSObject                   //实况天气

@property(nonatomic, copy)NSString *fl;                 //体感温度
@property(nonatomic, copy)NSString *hum;                //相对湿度
@property(nonatomic, copy)NSString *pcpn;               //降水量
@property(nonatomic, copy)NSString *pres;               //气压
@property(nonatomic, copy)NSString *tmp;               //温度
@property(nonatomic, strong)WeatherCondModel *cond;     //天气状况
@property(nonatomic, strong)WeatherWindModel *wind;     //风力风向

@end

@interface WeatherWindModel : NSObject                  //风力风向

@property(nonatomic, copy)NSString *deg;                //风向
@property(nonatomic, copy)NSString *dir;                //风向描述
@property(nonatomic, copy)NSString *sc;                 //风力
@property(nonatomic, copy)NSString *spd;                //风速

@end

@interface WeatherCondModel : NSObject                  //天气状况
@property(nonatomic, copy)NSString *code;               //天气状况代码
@property(nonatomic, copy)NSString *txt;                //天气状况描述
@end

@interface WeatherDailyModel : NSObject                 //天气预报

@property(nonatomic, copy)NSString *date;               //预报日期
@property(nonatomic, copy)NSString *hum;                //相对湿度
@property(nonatomic, strong)WeatherAstroModel *astro;   //天文数值
@property(nonatomic, strong)WeatherTempModel *tmp;      //温度
@property(nonatomic, strong)WeatherDailyCondModel *cond;//天气状况
@end

@interface WeatherAstroModel : NSObject                 //天文数值

@property(nonatomic, copy)NSString *sr;                 //日出时间
@property(nonatomic, copy)NSString *ss;                 //日落时间
@end

@interface WeatherTempModel : NSObject                  //温度
@property(nonatomic, copy)NSString *max;                //最高温度
@property(nonatomic, copy)NSString *min;                //最低温度
@end

@interface WeatherDailyCondModel : NSObject             //天气状况
@property(nonatomic, copy)NSString *code_d;             //白天天气状况码
@property(nonatomic, copy)NSString *code_n;             //晚上天气状况码
@property(nonatomic, copy)NSString *txt_d;              //白天天气状况描述
@property(nonatomic, copy)NSString *txt_n;              //晚上天气状况描述
@end

@interface WeatherBasicInfoModel : NSObject

@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *txt;
@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *date;
@property(nonatomic, copy)NSString *tmp;
@property(nonatomic, copy)NSString *sunr;
@property(nonatomic, copy)NSString *suns;
@property(nonatomic, copy)NSString *hum;
@property(nonatomic, assign)CGFloat txtWidth;

@end

@interface WeatherDailyForcastModel : NSObject
@property(nonatomic,copy)NSString *fl;
@property(nonatomic,copy)NSString *wind;
@property(nonatomic, strong)NSMutableArray *dailyForcast;

@end

@interface WeatherTempTrendModel : NSObject

@property(nonatomic, strong)NSString *code;
@property(nonatomic, assign)CGFloat highTmp;
@property(nonatomic, assign)CGFloat lowTmp;
@property(nonatomic, assign)CGFloat centerX;

@end

@interface WeatherCityModel : NSObject<NSCoding>

@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *tmp;
@property(nonatomic, copy)NSString *address;
@end

@interface WeatherCacheModel : NSObject

@property(nonatomic, assign)NSUInteger  _id;
@property(nonatomic, copy)NSString *cityKey;
@property(nonatomic, copy)NSString *cityName;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *cond;
@property(nonatomic, copy)NSString *temp;
@property(nonatomic, assign)NSInteger cityIndex;

@end
