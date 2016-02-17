//
//  NJGlobalConstData.h
//  SimpleWeather
//
//  Created by 陈剑南 on 12/31/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kApiKeyName @"apikey"

#define kApiKey @"fd235aacd393e4b2e77254dcbd9b66c2"

#define kAppDataApiPatameterKeyName @"city"

#define kAppDataApi @"http://apis.baidu.com/heweather/pro/weather"

#define GlobalScreenHeight [UIScreen mainScreen].bounds.size.height

#define GlobalScreenWidth [UIScreen mainScreen].bounds.size.width

#define kThemeColor [UIColor colorWithRed:.29 green:.77 blue:.97 alpha:1]

#define  iPhone5s   (GlobalScreenWidth == 320.f && GlobalScreenHeight == 568.f ? YES : NO)
#define  iPhone6s      (GlobalScreenWidth >= 375.f && GlobalScreenHeight >= 667.f ? YES : NO)

#define isAnimationOn @"isAnimationOn"
#define isPushOn @"isPushOn"
#define locationCity @"locationCity"


