//
//  CityFMDatabaseQueue.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "CityFMDatabaseQueue.h"

@interface CityFMDatabaseQueue()

{
   FMDatabaseQueue* queue;;
}

@end

@implementation CityFMDatabaseQueue


+ (CityFMDatabaseQueue *)sharedInstance{
    __strong static id databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseQueue = [[CityFMDatabaseQueue alloc]init];
    });
    return databaseQueue;
}

- (instancetype)init{
    if(self = [super init]){
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"citysDB" ofType:@"sqlite"];
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
