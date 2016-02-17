//
//  AppDelegate.m
//  SimpleWeather
//
//  Created by 陈剑南 on 11/30/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "WeatherDatabaseManager.h"
#import "YYModel.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *frontVC = [[ViewController alloc]init];
    MenuViewController *rearVC = [[MenuViewController alloc]init];
    rearVC.delegate = frontVC;
    UINavigationController *frontNC = [[UINavigationController alloc]initWithRootViewController:frontVC];
    UINavigationController *rearNC = [[UINavigationController alloc]initWithRootViewController:rearVC];
    SWRevealViewController *revelVC = [[SWRevealViewController alloc]initWithRearViewController:rearNC frontViewController:frontNC];
    self.window.rootViewController = revelVC;
    [self.window makeKeyAndVisible];
    
    
    [self initData];
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        [self removeNotification];
        NSString *text = [self getNotificationBody];
        if(text.length>0){
            [self addLocalNotification:text];
        }
    }else{
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
    
        return YES;
}

// 初始化设置数据
- (void)initData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *isAnimation = [user objectForKey:isAnimationOn];
    NSString *isPush = [user objectForKey:isPushOn];
    if(isAnimation.length == 0 && isPush.length == 0){
        [user setObject:@"YES" forKey:isAnimationOn];
        [user setObject:@"YES" forKey:isPushOn];
        [user synchronize];
    }
}


// 添加本地通知
-(void)addLocalNotification:(NSString *)text{
    
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    NSDate *fireDate =[NSDate dateWithTimeIntervalSince1970:0];
    notification.fireDate=fireDate;
    notification.repeatInterval=kCFCalendarUnitDay;
    notification.alertBody= text;
    notification.applicationIconBadgeNumber-=1;
    notification.alertAction=@"打开应用";
    notification.alertLaunchImage=@"Default";
    notification.soundName=@"msg.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 获取通知数据
- (NSString *)getNotificationBody{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *currentCity = [user objectForKey:locationCity];
    WeatherCacheModel *cacheModel;
    cacheModel = [[WeatherDatabaseManager manager]DBWeatherGetModelByCityName:currentCity];
    if(cacheModel == nil){
        cacheModel = [[[WeatherDatabaseManager manager]DBWeatherGETAllModels] firstObject];
    }
    
    NSArray *contents = [cacheModel.content componentsSeparatedByString:@"$"];
    NSString *string = [[NSDate date] stringWithFormat:@"yyyy.MM.dd"];
    NSUInteger location = [cacheModel.content rangeOfString:string].location;
    if( location == 0){
        return [NSString stringWithFormat:@"%@ %@",currentCity,contents[0]];
    }else if(location == 20){
         return [NSString stringWithFormat:@"%@ %@",currentCity,contents[1]];
    }else if(location == NSNotFound){
        return @"";
    }else{
        return @"";
    }
}

#pragma mark 移除本地通知
-(void)removeNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        [self removeNotification];
        NSString *text = [self getNotificationBody];
        if(text.length>0){
            [self addLocalNotification:text];
        }        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [user setObject:@"YES" forKey:isPushOn];
        [user synchronize];
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"NO" forKey:isPushOn];
        [user synchronize];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
