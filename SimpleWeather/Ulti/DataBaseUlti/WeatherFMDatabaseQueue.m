//
//  WeatherFMDatabaseQueue.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherFMDatabaseQueue.h"

@interface WeatherFMDatabaseQueue()

{
    FMDatabaseQueue* queue;;
}

@end

@implementation WeatherFMDatabaseQueue


+ (WeatherFMDatabaseQueue *)sharedInstance{
    __strong static id databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseQueue = [[WeatherFMDatabaseQueue alloc]init];
    });
    return databaseQueue;
}

- (instancetype)init{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath =[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"/weatherDB"];

        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (void)initDatabase:(void(^)(FMDatabase*))block{
    [queue inDatabase:^(FMDatabase *db){
        block(db);
    }];
}
@end
