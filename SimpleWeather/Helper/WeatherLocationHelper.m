//
//  WeatherLocationHelper.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/2/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherLocationHelper.h"
#import "WeatherDatabaseManager.h"

@interface WeatherLocationHelper()<CLLocationManagerDelegate>

@property(nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation WeatherLocationHelper

+ (WeatherLocationHelper *)helper{
    static WeatherLocationHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WeatherLocationHelper alloc]init];
    });
    return helper;
}

- (void)startLocation{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
    }
    
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"定位服务未打开");
    }
    
//    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
//        [_locationManager requestAlwaysAuthorization];
//    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
//        
//       
//    }

     [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: [locations objectAtIndex:0] completionHandler:^(NSArray *array, NSError *error){
        if(array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *cityName = placemark.locality;//区名，eg,朝阳区
            cityName =  [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:cityName forKey:locationCity];
            [user synchronize];
            if(self.delegate && [self.delegate respondsToSelector:@selector(weatherLocation:didSuccess:)]){
                if(self.isFirstTime){
                    [self.delegate weatherLocation:self didSuccess:cityName];
                }else{
                    [self.delegate weatherLocation:self didSuccess:nil];
                }
            }
            
            
            NSLog(@"%@",cityName);
        }
    }];
    
    [self.locationManager stopUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
   if ([error code] == kCLErrorDenied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weatherLocationDidClose:)]) {
            [self.delegate weatherLocationDidClose:self];
        }
   } if ([error code] == kCLErrorLocationUnknown) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weatherLocation:didFailed:)]) {
            [self.delegate weatherLocation:self didFailed:error];
        }
    }
}

@end
