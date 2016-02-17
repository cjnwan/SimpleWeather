//
//  CityDatabaseManager.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDatabaseManager : NSObject

+ (CityDatabaseManager *)manager;

- (NSMutableArray *)getCityNameBySearchKey:(NSString *)key;

@end
