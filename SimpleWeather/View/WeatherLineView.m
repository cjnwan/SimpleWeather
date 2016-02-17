//
//  WeatherLineView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/6/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherLineView.h"

@interface WeatherLineView()
@property(nonatomic, assign)NSInteger maxHigh;
@property(nonatomic, assign)NSInteger minLow;
@property(nonatomic, strong)NSMutableArray *trendModel;
@property(nonatomic, strong)NSMutableArray *highTemps;
@property(nonatomic, strong)NSMutableArray *lowTemps;
@property(nonatomic, strong)UIBezierPath *topLinePath;
@property(nonatomic, strong)UIBezierPath *bottomLinePath;
@property(nonatomic, strong)UIBezierPath *topBezier;
@property(nonatomic, strong)UIBezierPath *bottomBezier;
@property(nonatomic, strong)UIBezierPath *maskBezier;
@property(nonatomic, assign)BOOL drawMask;

@end

@implementation WeatherLineView

- (instancetype)initWithFrame:(CGRect)frame andTrendModels:(NSMutableArray *)trendModel{
    if(self =[ super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.trendModel =trendModel;
        self.maxHigh = CGFLOAT_MIN;
        self.minLow = CGFLOAT_MAX;
        [self setupData];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    
    CGFloat height = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect)-40;
    [[UIColor colorWithRGB:@"0x1a3a62" ] set];
    UIBezierPath *linetop = [UIBezierPath bezierPathWithRect:CGRectMake(20, 0, width, 1)];
    [linetop fill];
    UIBezierPath *lineTwo = [UIBezierPath bezierPathWithRect:CGRectMake(20, height/3, width, 1)];
    [lineTwo fill];
    UIBezierPath *lineThree = [UIBezierPath bezierPathWithRect:CGRectMake(20, height/3*2, width, 1)];
    [lineThree fill];
    UIBezierPath *lineBottom = [UIBezierPath bezierPathWithRect:CGRectMake(20, height-1, width, 1)];
    [lineBottom fill];
    
    CGFloat maxBetween = self.maxHigh - self.minLow;
    
    for (int i = 0 ;i<6 && i<self.trendModel.count; i++) {
        
        WeatherTempTrendModel *model = (WeatherTempTrendModel*)self.trendModel[i];
        CGPoint topPoint = CGPointMake(model.centerX-4,self.height+4- (model.highTmp-self.minLow)/maxBetween*self.height);
        [self.topBezier moveToPoint:topPoint];
          [self.topBezier addArcWithCenter:topPoint radius:4 startAngle:0 endAngle:2*M_PI clockwise:YES];
        if(i==0){
            [self.topLinePath moveToPoint:topPoint];
        }else{
             [self.topLinePath addLineToPoint:topPoint];
            [self.topLinePath moveToPoint:topPoint];
           
        }
        
    }
    
    [[UIColor yellowColor]set];
    [self.topBezier fill];
    
    CGPoint firstPoint;
    CGPoint maskPoint;
    
    for (int i = 0 ;i<6 && i<self.trendModel.count; i++) {
        WeatherTempTrendModel *model = (WeatherTempTrendModel*)self.trendModel[i];
        CGPoint bottomPoint = CGPointMake(model.centerX-3, self.height-4- (model.lowTmp-self.minLow)/maxBetween*self.height);
        [self.bottomBezier moveToPoint:bottomPoint];
        [self.bottomBezier addArcWithCenter:bottomPoint radius:3 startAngle:0 endAngle:2*M_PI clockwise:YES];

        if(i==0){
            maskPoint = CGPointMake(bottomPoint.x, bottomPoint.y+3);
            [self.bottomLinePath moveToPoint:bottomPoint];
            firstPoint = CGPointMake(model.centerX-3, self.height-3);
            [self.maskBezier moveToPoint:firstPoint];
            [self.maskBezier addLineToPoint:maskPoint];
            
        }else{
            maskPoint = CGPointMake(bottomPoint.x, bottomPoint.y+3);
            [self.bottomLinePath addLineToPoint:bottomPoint];
            [self.bottomLinePath moveToPoint:bottomPoint];
            
            [self.maskBezier addLineToPoint:maskPoint];
        }
        if(i==5){
            [self.maskBezier addLineToPoint:CGPointMake(model.centerX, self.height+3)];
            [self.maskBezier addLineToPoint:firstPoint];
        }
    }
    
    
    
    [[UIColor colorWithRGB:@"0x50c6f5"]set];
    [self.bottomBezier fill];
    
    if(self.drawMask){
        self.drawMask = NO;
        [[UIColor colorWithRGB:@"133A62"]set];
        [self.maskBezier fill];
    }
    
    [[NSString stringWithFormat:@"%zd℃",self.maxHigh] drawAtPoint:CGPointMake(0, 0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor yellowColor]}];
    
      [[NSString stringWithFormat:@"%zd℃",self.minLow] drawAtPoint:CGPointMake(0, self.height-14) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRGB:@"0x50c6f5"]}];
    
}

#pragma mark - Public Method



- (void)startTopLineAnimation{
    CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
    shapeLine.strokeColor = [UIColor yellowColor].CGColor;
    shapeLine.lineWidth = 1;
    [self.layer addSublayer:shapeLine];
    shapeLine.path = self.topLinePath.CGPath;
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue   = @1.0f;
    
    [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    shapeLine.strokeEnd = 1.0;
    
    [CATransaction commit];
}

- (void)startBottomAnimation{
    CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
    shapeLine.strokeColor = [UIColor colorWithRGB:@"0x50c6f5"].CGColor;
    shapeLine.lineWidth = 1;
    [self.layer addSublayer:shapeLine];
    shapeLine.path = _bottomLinePath.CGPath;
    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue   = @1.0f;
    
    [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    shapeLine.strokeEnd = 1.0;
    
    [CATransaction commit];
    
    [self startMaskAnimation];
}

- (void)startMaskAnimation{
    self.drawMask = YES;
    [self setNeedsDisplay];
    
}

#pragma mark - Private Methods

- (void)setupData{
    if(self.trendModel.count>0){
        for (int i=0; i<6 && i<self.trendModel.count; i++) {
            WeatherTempTrendModel *model = (WeatherTempTrendModel*)self.trendModel[i];
            
            if(model.highTmp>=self.maxHigh){
                self.maxHigh = model.highTmp;
            }
            
            if(self.minLow> model.lowTmp){
                self.minLow = model.lowTmp;
            }
            [self.highTemps addObject:[NSNumber numberWithFloat:model.highTmp]];
            [self.lowTemps addObject:[NSNumber numberWithFloat:model.lowTmp]];
        }
    }
}

#pragma mark - Getters and Setters

- (NSMutableArray *)highTemps{
    if(!_highTemps){
        _highTemps = [NSMutableArray array];
    }
    return _highTemps;
}

-(NSMutableArray *)lowTemps{
    if(!_lowTemps){
        _lowTemps = [NSMutableArray array];
    }
    return _lowTemps;
}

- (UIBezierPath *)topLinePath{
    if(!_topLinePath){
        _topLinePath = [UIBezierPath bezierPath];
    }
    return _topLinePath;
}

- (UIBezierPath *)bottomLinePath{
    if(!_bottomLinePath){
        _bottomLinePath = [UIBezierPath bezierPath];
    }
    return _bottomLinePath;
}

- (UIBezierPath *)topBezier{
    if(!_topBezier){
        _topBezier = [UIBezierPath bezierPath];
    }
    return _topBezier;
}

- (UIBezierPath *)bottomBezier{
    if(!_bottomBezier){
        _bottomBezier = [UIBezierPath bezierPath];
    }
    return _bottomBezier;
}

- (UIBezierPath *)maskBezier{
    if(!_maskBezier){
        _maskBezier = [UIBezierPath bezierPath];
    }
    return _maskBezier;
}

@end
