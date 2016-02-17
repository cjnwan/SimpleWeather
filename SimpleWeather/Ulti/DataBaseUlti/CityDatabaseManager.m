//
//  CityDatabaseManager.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "CityDatabaseManager.h"
#import "CityFMDatabaseQueue.h"
#import "FMDB.h"

@interface CityDatabaseManager()

@property(nonatomic, strong)FMDatabase *database;

@end

@implementation CityDatabaseManager

+(CityDatabaseManager *)manager{
    static CityDatabaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CityDatabaseManager alloc]init];
    });
    return manager;
}
- (id)init{
    if(self = [super init]){
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"citysDB" ofType:@"sqlite"];
        self.database = [FMDatabase databaseWithPath:dbPath];
        if([self.database open]){
            [self.database setShouldCacheStatements:YES];
            
        }else{
            
        }
    }
    return self;
}

- (NSMutableArray *)getCityNameBySearchKey:(NSString *)key{
    
    NSMutableArray *result = [NSMutableArray array];
     CityFMDatabaseQueue * queue = [CityFMDatabaseQueue sharedInstance];
     [queue initDatabase:^(FMDatabase *db) {
         NSString *where = [NSString stringWithFormat:@" where %@ like '%%%@%%' ",@"nAMECN",key];
         NSString* sql = [NSString stringWithFormat:@"SELECT * FROM `%@` %@", @"cityTable",where];
         FMResultSet * rs = [db executeQuery:sql];
         while([rs next]){
            NSString *cityName = [rs stringForColumnIndex:2];
             [result addObject:cityName];
         }
     }];
         return result;
}

@end
