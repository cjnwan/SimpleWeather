//
//  AddCityViewController.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCityDelegate <NSObject>

- (void)didSelectCity:(NSString *)city;

@end

@interface AddCityViewController : UIViewController

@property(nonatomic, weak)id<AddCityDelegate>delegate;


@end
