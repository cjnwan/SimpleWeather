//
//  WeatherBounceView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/6/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherBounceView.h"

@interface WeatherBounceView()

@property(nonatomic, assign)CGFloat from;
@property(nonatomic, assign)CGFloat to;
@property(nonatomic, strong)CADisplayLink *displayLink;
@property(nonatomic, strong)CAShapeLayer *shaperLayer;
@property(nonatomic, strong)UIColor *backColor;


@end

@implementation WeatherBounceView

#pragma mark - LiftCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backColor = [UIColor colorWithRGB:@"0x122f52"];
    }
    return self;
}

#pragma mark - Override Draw

- (void)drawRect:(CGRect)rect{
    CALayer *layer = self.layer.presentationLayer;
    
    
    
    CGFloat progress = 1 - (layer.position.y - self.to) / (self.from - self.to);
    
    if(progress>1){
        progress = 0;
    }
    
    CGFloat height = CGRectGetHeight(rect);
    CGFloat deltaHeight = height  * (0.5 - fabs(progress - 0.5));
    
    CGPoint topLeft = CGPointMake(0, deltaHeight);
    CGPoint topRight = CGPointMake(CGRectGetWidth(rect), deltaHeight);
    CGPoint bottomLeft = CGPointMake(0, height);
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(rect), height);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [self.backColor setFill];
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight controlPoint:CGPointMake(CGRectGetMidX(rect), 0)];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:bottomLeft];
    [path closePath];
    [path fill];

}

#pragma mark - Public Methods

- (void)startAnimation:(CGFloat)from to:(CGFloat)to{
    self.from = from;
    self.to = to;
    self.displayLink.paused = NO;
}

- (void)completeAnimation{
    
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
    
}

#pragma mark - Private Methods

- (void)tick:(CADisplayLink *)displayLink{
    [self setNeedsDisplay];
}



#pragma mark - Getters and Setters

- (CADisplayLink *)displayLink{
    if(!_displayLink){
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (CAShapeLayer *)shaperLayer{
    if(!_shaperLayer){
        _shaperLayer = [[CAShapeLayer alloc]init];
        _shaperLayer.frame = self.bounds;
        _shaperLayer.backgroundColor = self.backColor.CGColor;
    }
    return _shaperLayer;
}



@end
