//
//  SettingDataHelper.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDataHelper : NSObject

+ (SettingDataHelper *)helper;

- (NSMutableArray *)getSettingData;

@end
