//
//  CityFMDatabaseQueue.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CityFMDatabaseQueue : NSObject

+ (CityFMDatabaseQueue *)sharedInstance;

- (void)initDatabase:(void(^)(FMDatabase*))block;

@end
