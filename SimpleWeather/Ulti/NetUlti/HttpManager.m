//
//  HttpManager.m
//  SimpleWeather
//
//  Created by 陈剑南 on 12/31/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
#import "WeatherDataModel.h"
#import "YYModel.h"
#import "WeatherDataHelper.h"
#import "WeatherDatabaseManager.h"

@implementation HttpManager

+ (HttpManager *)manager{
    static HttpManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[HttpManager alloc]init];
    });
    return httpManager;
}

- (void)getWeatherDataByCityName:(NSString *)cityName dataHandle:(void (^)(WeatherDataModel * _Nonnull dataModel))dataHandle{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{kAppDataApiPatameterKeyName:cityName};
    
    [sessionManager.requestSerializer setValue:kApiKey forHTTPHeaderField:kApiKeyName];
    
    [sessionManager GET:kAppDataApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *dic = (NSArray *)responseObject[@"HeWeather data service 3.0"];
        WeatherDataModel *dataModel   = [WeatherDataModel yy_modelWithDictionary:dic[0]];
        
        WeatherCacheModel *cacheModel = [[WeatherCacheModel alloc]init];
        cacheModel.cond = [[WeatherDataHelper helper]getWeatherIconByCode:dataModel.now.cond.code isDay:YES];
        cacheModel.temp = [NSString stringWithFormat:@"%@°",dataModel.now.tmp];
        cacheModel.cityName = dataModel.basic.city;
        NSDate *now = [NSDate date];
        NSDate *tomorrow = [now dateByAddingDays:1];
        WeatherDailyModel *tomorrowModel = dataModel.daily_forecast[1];
        NSString *todayContent = [NSString stringWithFormat:@"%@ %@ %@摄氏度",[now stringWithFormat:@"yyyy.MM.dd"],dataModel.now.cond.txt,cacheModel.temp];
        NSString *tomorrowContent = [NSString stringWithFormat:@"%@ %@ %@~%@摄氏度",[tomorrow stringWithFormat:@"yyyy.MM.dd"],tomorrowModel.cond.code_d,tomorrowModel.tmp.min,tomorrowModel.tmp.max];
        cacheModel.content = [NSString stringWithFormat:@"%@$%@",todayContent,tomorrowContent];
        if(cacheModel && cacheModel.cityName.length>0){
            
            if(![[WeatherDatabaseManager manager]DBWeatherIsExistModelByCityKey:cacheModel.cityName]){
                [[WeatherDatabaseManager manager]DBWeatherInsertModel:cacheModel];
            }else{
                [[WeatherDatabaseManager manager]DBWeatherUpdateBean:cacheModel];
            }
        dataHandle(dataModel);
        }
    ;
        NSLog(@"获取数据成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取数据失败！！！！");
    }];
}

- (void)getWeatherDataByCityNames:(NSArray *)cityNames dataHandle:(void (^)(NSArray * _Nonnull dataModels))dataHandle{
    
    NSMutableArray *array = [NSMutableArray array];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setValue:kApiKey forHTTPHeaderField:kApiKeyName];
    NSMutableArray *dataModels = [NSMutableArray array];
    
    dispatch_group_t getDataGroup = dispatch_group_create();
    
    
    for (int i =0; i<cityNames.count; i++) {
        NSString *cityName = (NSString *)cityNames[i];
        NSDictionary *parameters = @{kAppDataApiPatameterKeyName:cityName};
        
        dispatch_group_enter(getDataGroup);
        
        [sessionManager GET:kAppDataApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *dic = (NSArray *)responseObject[@"HeWeather data service 3.0"];
            [array addObject:dic];
            WeatherDataModel *dataModel   = [WeatherDataModel yy_modelWithDictionary:dic[0]];
            [dataModels addObject:dataModel];
            NSLog(@"获取数据成功");
            dispatch_group_leave(getDataGroup);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"获取数据失败！！！！");
            dispatch_group_leave(getDataGroup);
        }];
    }
    
        dispatch_group_notify(getDataGroup, dispatch_get_main_queue(), ^{ // 4
            
                for (int i=0; i<dataModels.count; i++) {
                    WeatherDataModel *dataModel = dataModels[i];
                    WeatherCacheModel *cacheModel = [[WeatherCacheModel alloc]init];
                    cacheModel.cond = [[WeatherDataHelper helper]getWeatherIconByCode:dataModel.now.cond.code isDay:YES];
                    cacheModel.temp = [NSString stringWithFormat:@"%@°",dataModel.now.tmp];
                    cacheModel.cityName = dataModel.basic.city;
                    NSDate *now = [NSDate date];
                    NSDate *tomorrow = [now dateByAddingDays:1];
                    WeatherDailyModel *tomorrowModel = dataModel.daily_forecast[1];
                    NSString *todayContent = [NSString stringWithFormat:@"%@ %@ %@℃",[now stringWithFormat:@"yyyy.MM.dd"],dataModel.now.cond.txt,cacheModel.temp];
                    NSString *tomorrowContent = [NSString stringWithFormat:@"%@ %@ %@~%@℃",[tomorrow stringWithFormat:@"yyyy.MM.dd"],tomorrowModel.cond.txt_d,tomorrowModel.tmp.min,tomorrowModel.tmp.max];
                    cacheModel.content = [NSString stringWithFormat:@"%@$%@",todayContent,tomorrowContent];
                    if(![[WeatherDatabaseManager manager]DBWeatherIsExistModelByCityKey:cacheModel.cityName]){
                        [[WeatherDatabaseManager manager]DBWeatherInsertModel:cacheModel];
                    }else{
                        [[WeatherDatabaseManager manager]DBWeatherUpdateBean:cacheModel];
                    }
                }

            
            
            if (dataHandle) {
                dataHandle(dataModels);
            }
        });
}

@end
