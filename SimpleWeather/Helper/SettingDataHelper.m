//
//  SettingDataHelper.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "SettingDataHelper.h"
#import "SettingDataModel.h"

@implementation SettingDataHelper

+ (SettingDataHelper *)helper{
    static SettingDataHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[SettingDataHelper alloc]init];;
    });
    return helper;
}

- (NSArray *)getSettingData{
    SettingDataModel *push = [[SettingDataModel alloc]initWithType:SettingItemTypeChoose Title:@"推送通知" Content:@""];
    SettingDataModel *animation = [[SettingDataModel alloc]initWithType:SettingItemTypeChoose Title:@"天气动画" Content:@""];
    SettingDataModel *review = [[SettingDataModel alloc]initWithType:SettingItemTypeDefault Title:@"赏个好评" Content:@""];
    SettingDataModel *revision = [[SettingDataModel alloc]initWithType:SettingItemTypeContent Title:@"版本" Content:@"1.0"];
    
    NSArray *group = [NSArray array];
    
    NSArray *group1 = @[push];
    NSArray *group2 = @[animation];
    NSArray *group3 = @[review,revision];
    
    group = @[group1,group2,group3];
    return group;
    
}

@end
