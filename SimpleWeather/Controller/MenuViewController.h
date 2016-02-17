//
//  MenuViewController.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;
@protocol WeatherOperationDeleaget <NSObject>

- (void)viewConroller:(MenuViewController *)viewController weatherAddOperation:(NSString *)cityName;

- (void)viewConroller:(MenuViewController *)viewController weatherRemoveOperation:(NSInteger)index;

- (void)viewConroller:(MenuViewController *)viewController weatherSelectOperation:(NSInteger)index;
@end

@interface MenuViewController : UIViewController
@property(nonatomic, weak)id<WeatherOperationDeleaget>delegate;
@end
