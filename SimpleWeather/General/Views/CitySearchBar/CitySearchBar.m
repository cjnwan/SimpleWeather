//
//  CitySearchBar.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/12/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "CitySearchBar.h"

@interface CitySearchBar()

@property(nonatomic, strong)UIFont *preferredFont;
@property(nonatomic, strong)UIColor *preferredTextColor;

@end

@implementation CitySearchBar

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor{
    if(self = [super initWithFrame:frame]){
        self.preferredFont = font;
        self.preferredTextColor = textColor;
    }
    return self;
}

#pragma mark - Override drawRect

- (void)drawRect:(CGRect)rect{
    NSInteger index = [self indexOfAccessibilityElement:self];
    UITextField *searchField = self.subviews[0].subviews[index];
    [searchField resignFirstResponder];
    searchField.frame = CGRectMake(5.0, 5.0, self.width - 10.0, self.height - 10.0);
    searchField.font = self.preferredFont;
    searchField.textColor = self.preferredTextColor;
    searchField.backgroundColor = self.barTintColor;
    
    CGPoint startPoint = CGPointMake(0, self.height);
    CGPoint endPoint = CGPointMake(self.width, self.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.preferredTextColor.CGColor;
    shapeLayer.lineWidth = 2.5;
    [self.layer addSublayer:shapeLayer];
}

- (NSInteger)indexOfAccessibilityElement:(id)element{
    NSInteger index;
    UIView *searchBarView = self.subviews[0];
    
    for (int i=0; i<searchBarView.subviews.count; i++) {
        if([searchBarView.subviews[i] isKindOfClass:[UITextField class]]){
            index = i;
            break;
        }
    }
    return index;
}

@end
