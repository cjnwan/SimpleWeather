//
//  SettingDataModel.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "SettingDataModel.h"

@implementation SettingDataModel

- (instancetype)initWithType:(SettingItemType)type Title:(NSString *)title Content:(NSString *)content{
    if(self = [super init]){
    self.type = type;
    self.title = title;
    self.content = content;
    }
    return self;

}

@end
