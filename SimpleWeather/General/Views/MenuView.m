//
//  MenuView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/1/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *pathTop = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, 5) cornerRadius:2.5];
    [[UIColor whiteColor]set];
    [pathTop fill];
    
    UIBezierPath *pathCenter = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 10, self.width, 5) cornerRadius:2.5];
    [[UIColor whiteColor]set];
    [pathCenter fill];
    
    UIBezierPath *pathBottom = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 20, self.width, 5) cornerRadius:2.5];
    [[UIColor whiteColor]set];
    [pathBottom fill];
}

@end
