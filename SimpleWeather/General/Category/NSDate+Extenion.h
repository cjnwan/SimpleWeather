//
//  NSDate+Extenion.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extenion)

@property (nonatomic, readonly) NSInteger weekday;

- (NSString *)stringWithFormat:(NSString *)format;
- (NSDate *)dateByAddingDays:(NSInteger)days;

@end
