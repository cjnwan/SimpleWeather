//
//  WeatherFMDatabaseQueue.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class WeatherFMDatabaseQueue;

@interface WeatherFMDatabaseQueue : NSObject

+ (WeatherFMDatabaseQueue *)sharedInstance;

- (void)initDatabase:(void(^)(FMDatabase*))block;

@end
