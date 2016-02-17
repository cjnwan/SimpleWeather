//
//  SettingDataModel.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SettingItemType){
    SettingItemTypeDefault,//title,arrow
    SettingItemTypeChoose,//title,check
    SettingItemTypeContent//title,text
};

@interface SettingDataModel : NSObject

@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, assign)SettingItemType type;
- (instancetype)initWithType:(SettingItemType)type Title:(NSString *)title Content:(NSString *)content;

@end
