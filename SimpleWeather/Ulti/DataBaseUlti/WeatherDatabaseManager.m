//
//  WeatherDatabaseManager.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherDatabaseManager.h"
#import "FMDB.h"
#import "WeatherFMDatabaseQueue.h"

@interface WeatherDatabaseManager()

@property(nonatomic, strong)FMDatabase *dataBase;

@end

@implementation WeatherDatabaseManager


+ (WeatherDatabaseManager *)manager{
    static WeatherDatabaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeatherDatabaseManager alloc]init];
    });
    return manager;
}

- (instancetype)init{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath =[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"/weatherDB"];
        
       
        self.dataBase = [FMDatabase databaseWithPath:dbPath];
        if([self.dataBase open]){
            [self createTables];
        }
    }
    return self;
}

- (void)createTables{
    if([self.dataBase beginTransaction]){
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \
                         `%@` (\
                         'id' INTEGER PRIMARY KEY AUTOINCREMENT, \
                         'cityKey' TEXT UNIQUE, \
                         'cityName' TEXT, \
                         'content' TEXT, \
                         'cond' TEXT, \
                         'temp' TEXT, \
                         'cityIndex' INTEGER DEFAULT 0) ",@"WeatherTable"];
        BOOL res = [self.dataBase executeUpdate:sql];
        if(res){
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
        [self.dataBase commit];
    }
}

- (BOOL)DBWeatherInsertModel:(WeatherCacheModel *)model{
    
    NSAssert(model.cityName != nil && [model.cityName length] > 0, @"cityName must be non-nil");
        __block BOOL res;
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase * dataBase) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO `%@` ( \
                         cityKey, \
                         cityName, \
                         content, \
                         cond, \
                         temp, \
                         cityIndex)\
                         VALUES(:cityKey,:cityName,:content,:cond,:temp,:cityIndex) ",@"WeatherTable"];
        res = [dataBase executeUpdate:sql,model.cityKey,model.cityName,model.content,model.cond,model.temp,[NSNumber numberWithInt:0]];
        if(res){
            
            model._id = [dataBase lastInsertRowId];
        }else{
            
        }
    }];
    return res;
}

- (BOOL)DBWeatherIsExistModelByCityKey:(NSString *)cityKey{
    __block NSUInteger count;
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) FROM `%@` WHERE cityName like '%@' ",@"WeatherTable",cityKey];
        count = [db intForQuery:sql];
    }];
    return count == 0? NO:YES;
}

- (BOOL)DBWeatherUpdateBean:(WeatherCacheModel *)model{
    
    __block BOOL res;
    
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE `%@` SET content =:content,cond=:cond,temp=:temp WHERE cityName like '%@' ",@"WeatherTable",model.cityName];
        res = [db executeUpdate:sql,model.content,model.cond,model.temp];
    }];
    
       return res;
}

- (BOOL)DBWeatherDeleteModel:(NSString *)cityName{
    __block BOOL res;
    
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from `%@` where cityName = '%@' ",@"WeatherTable",cityName];
        res = [db executeUpdate:sql];
    }];
    
    return res;

}

- (WeatherCacheModel *)DBWeatherGetModelByCityName:(NSString *)cityName{
    NSMutableArray *result = [NSMutableArray array];
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE cityName = '%@'" ,@"WeatherTable",cityName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WeatherCacheModel *cacheModel = [[WeatherCacheModel alloc]init];
            cacheModel.cityName = [rs stringForColumnIndex:2];
            cacheModel.content = [rs stringForColumnIndex:3];
            cacheModel.cond = [rs stringForColumnIndex:4];
            cacheModel.temp = [rs stringForColumnIndex:5];
            
            [result addObject:cacheModel];
        }
        [rs close];
    }];
    return [result firstObject];

 
}

- (NSMutableArray *)DBWeatherGetAllCitys{
    NSMutableArray *result = [NSMutableArray array];
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` ",@"WeatherTable"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            // WeatherCacheModel *cb = [[WeatherCacheModel alloc]init];
            NSString *cityName = [rs stringForColumnIndex:2];
            
            [result addObject:cityName];
        }
        [rs close];
    }];
    return result;
}

- (NSMutableArray *)DBWeatherGETAllModels{
    NSMutableArray *result = [NSMutableArray array];
    WeatherFMDatabaseQueue * queue = [WeatherFMDatabaseQueue sharedInstance];
    
    [queue initDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` ",@"WeatherTable"];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            WeatherCacheModel *cacheModel = [[WeatherCacheModel alloc]init];
            cacheModel.cityName = [rs stringForColumnIndex:2];
            cacheModel.cond = [rs stringForColumnIndex:4];
            cacheModel.temp = [rs stringForColumnIndex:5];
            
            [result addObject:cacheModel];
        }
        [rs close];
    }];
    return result;
}


@end
