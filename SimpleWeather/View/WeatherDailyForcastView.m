//
//  WeatherDailyForcastView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherDailyForcastView.h"
#import "WeatherLineView.h"

@interface WeatherDailyForcastView()

@property(nonatomic, strong)NSMutableArray *dailyCodeArray;
@property(nonatomic, strong)UIButton *windButton;
@property(nonatomic, strong)UIButton *bodyTmpButton;
@property(nonatomic, strong)WeatherLineView *lineView;
@property(nonatomic, strong)NSMutableArray *trendImages;
@property(nonatomic, strong)UIView *weekView;
@property(nonatomic, strong)UIView *weekDaysView;
@property(nonatomic, strong)NSMutableArray *weekDays;

@property(nonatomic, assign)CGFloat from;
@property(nonatomic, assign)CGFloat to;
@property(nonatomic, strong)CADisplayLink *displayLink;
@property(nonatomic, strong)CAShapeLayer *shaperLayer;
@property(nonatomic, strong)UIColor *backColor;

@end

@implementation WeatherDailyForcastView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        [self setupView];
        self.backgroundColor = [UIColor colorWithRGB:@"0x122f52"];
         self.backColor = [UIColor colorWithRGB:@"0x122f52"];
        [self setupPosition];
    }
    return self;
}

- (void)setupView{
   
    for (int i = 0; i<6; i++) {
        
        CGFloat topMargin = 12;
        CGFloat leftMargin = (self.width-32*6)/7;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftMargin+(32+leftMargin)*i, topMargin, 32, 32)];
        [self addSubview:imageView];
        [self.dailyCodeArray addObject:imageView];
    }
    [self addSubview:self.lineView];
    [self addSubview:self.windButton];
    [self addSubview:self.bodyTmpButton];
    if(iPhone6s){
        [self addSubview:self.weekView];
        [self addSubview:self.weekDaysView];
        NSInteger weekOfDay = [[NSDate date]weekday];
        for (int i=1; i<=6; i++) {
            CGFloat leftMargin = (self.width-32*6)/7;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+(32+leftMargin)*(i-1), 6, 32, 32)];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = (NSString *)self.weekDays[(weekOfDay+(i-1))%7];
            
            label.textColor = [UIColor colorWithRed:0.41 green:0.53 blue:0.65 alpha:1];
            [self.weekDaysView addSubview:label];
        }
    }
}

- (void)setupPosition{
    self.lineView.frame = CGRectMake(0, 56, self.width, 42*3);
    self.bodyTmpButton.frame = CGRectMake((self.width-100*2)/3, 184+12, 100, 30);
    self.windButton.frame =  CGRectMake((self.width-100*2)/3*2+100, 184+12, 100, 30);
}

#pragma mark - Override Draw

- (void)drawRect:(CGRect)rect{
    CALayer *layer = self.layer.presentationLayer;
    
    CGFloat progress = 1 - (layer.position.y - self.to) / (self.from - self.to);
    
    CGFloat height = CGRectGetHeight(rect);
    CGFloat deltaHeight = height / 2 * (0.5 - fabs(progress - 0.5));
    
    CGPoint topLeft = CGPointMake(0, deltaHeight);
    CGPoint topRight = CGPointMake(CGRectGetWidth(rect), deltaHeight);
    CGPoint bottomLeft = CGPointMake(0, height);
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(rect), height);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [self.backColor setFill];
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight controlPoint:CGPointMake(CGRectGetMidX(rect), 0)];
    [path addLineToPoint:bottomRight];
    [path addQuadCurveToPoint:bottomLeft controlPoint:CGPointMake(CGRectGetMidX(rect), height - deltaHeight)];
    [path closePath];
    [path fill];
}

#pragma mark - Public Property

- (void)setModel:(WeatherDailyForcastModel *)model{
    for (int i = 0; i<6 && i<model.dailyForcast.count; i++) {
        
        WeatherTempTrendModel *trend = (WeatherTempTrendModel*)model.dailyForcast[i];
      
        UIImageView *imageView = ((UIImageView *)self.dailyCodeArray[i]);
        imageView.image = [UIImage imageNamed:trend.code];
        trend.centerX = imageView.centerX;
    }
    
    [self.bodyTmpButton setTitle:model.fl forState:UIControlStateNormal];
    [self.windButton setTitle:model.wind forState:UIControlStateNormal];
    
    self.lineView = [[WeatherLineView alloc]initWithFrame:CGRectMake(0, 56, self.width, 126) andTrendModels:model.dailyForcast];
    [self addSubview:self.lineView];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isAnimationOn] isEqualToString:@"YES"]){
     [self initOriginalState];
    
    if(iPhone6s){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startWeekAnimation];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTrendAnimation];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTrendImagesAnimation];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startWindAnimation];
        
    });
    
    if(iPhone6s){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startWeekDaysAnimation];
        });
    }
    }else{

        self.windButton.alpha = 1;
        self.bodyTmpButton.alpha = 1;
        self.weekView.alpha = 1;
        self.weekDaysView.alpha = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.lineView startTopLineAnimation];
            [self.lineView startBottomAnimation];
        });
    }
}

#pragma mark - Public Method


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

#pragma mark - Private Method

- (void)tick:(CADisplayLink *)displayLink{
    [self setNeedsDisplay];
}

- (void)initOriginalState{
    
    self.windButton.alpha  = 0;
    self.bodyTmpButton.alpha = 0;
    self.weekView.alpha = 0;
    self.weekDaysView.alpha = 0;
    self.lineView.alpha = 0;
    self.windButton.transform = CGAffineTransformMakeTranslation(0, 20);
    self.bodyTmpButton.transform = CGAffineTransformMakeTranslation(0, 20);
    self.weekView.transform = CGAffineTransformMakeTranslation(0, 50);
    self.weekDaysView.transform = CGAffineTransformMakeTranslation(0, 50);
    
    for (int i = 0; i<6 ; i++) {
        
        UIImageView *imageView = ((UIImageView *)self.dailyCodeArray[i]);
        imageView.alpha = 0;
        imageView.transform = CGAffineTransformMakeTranslation(0, 56);
    }

}

- (void)startTrendImagesAnimation{
    
    for (int i=0; i<6; i++) {
        UIImageView *imageView = (UIImageView *)self.dailyCodeArray[i];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue = @(1);
        opacityAnimation.duration = 0.6;
        
        CASpringAnimation *imagePositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
        imagePositionAnimation.fromValue = @(imageView.layer.position.y);
        imagePositionAnimation.toValue = @(imageView.layer.position.y-56);
        imagePositionAnimation.mass = 1;
        imagePositionAnimation.stiffness = 100;
        imagePositionAnimation.damping = 10;
        imagePositionAnimation.duration = 1;
        imagePositionAnimation.initialVelocity = 0;
        
        imagePositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
        
        CAAnimationGroup *imageGroupAnimation = [[CAAnimationGroup alloc]init];
        imageGroupAnimation.animations =@[opacityAnimation, imagePositionAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self applyAnimationGroup:imageGroupAnimation toLayer:imageView.layer];
        });
    }
    
}

- (void)startTrendAnimation{
    
    CASpringAnimation *opacityAnimation = [CASpringAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.toValue = @(1);
    opacityAnimation.mass = 1;
    opacityAnimation.stiffness = 100;
    opacityAnimation.damping = 10;
    opacityAnimation.duration = 0.8;
    opacityAnimation.initialVelocity = 0;
    
    opacityAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    [self applyBasicAnimation:opacityAnimation toLayer:self.lineView.layer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lineView startTopLineAnimation];
        [self.lineView startBottomAnimation];
    });
}

- (void)startWindAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 0.8;
    
    CASpringAnimation *windPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    windPositionAnimation.fromValue = @(self.windButton.layer.position.y);
    if(iPhone6s){
    windPositionAnimation.toValue = @(self.windButton.layer.position.y-23);
    }else{
        windPositionAnimation.toValue = @(self.windButton.layer.position.y-20);
    }
    windPositionAnimation.mass = 1;
    windPositionAnimation.stiffness = 100;
    windPositionAnimation.damping = 10;
    windPositionAnimation.duration = 1.5;
    windPositionAnimation.initialVelocity = 0;
    
    windPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *windGroupAnimation = [[CAAnimationGroup alloc]init];
    windGroupAnimation.animations =@[opacityAnimation, windPositionAnimation];
    
    [self applyAnimationGroup:windGroupAnimation toLayer:self.windButton.layer];
    
    CASpringAnimation *tmpPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    tmpPositionAnimation.fromValue = @(self.bodyTmpButton.layer.position.y);
    if(iPhone6s){
    tmpPositionAnimation.toValue = @(self.bodyTmpButton.layer.position.y-23);
    }else{
        tmpPositionAnimation.toValue = @(self.bodyTmpButton.layer.position.y-20);
    }
    tmpPositionAnimation.mass = 1;
    tmpPositionAnimation.stiffness = 100;
    tmpPositionAnimation.damping = 10;
    tmpPositionAnimation.duration = 1.5;
    tmpPositionAnimation.initialVelocity = 0;
    
    tmpPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *tmpGroupAnimation = [[CAAnimationGroup alloc]init];
    tmpGroupAnimation.animations =@[opacityAnimation, tmpPositionAnimation];
    
    [self applyAnimationGroup:tmpGroupAnimation toLayer:self.bodyTmpButton.layer];
}

- (void)startWeekAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.2);
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 0.6;
    
    CASpringAnimation *positionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.fromValue = @(self.weekView.layer.position.y);
    positionAnimation.toValue = @(self.weekView.layer.position.y-56);
    positionAnimation.duration = 1;
    positionAnimation.delegate =self;
    positionAnimation.mass =0.8;
    positionAnimation.stiffness = 80;
    positionAnimation.damping = 10;
    positionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[opacityAnimation,positionAnimation];
    [self applyAnimationGroup:group toLayer:self.weekView.layer];
}

- (void)startWeekDaysAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.2);
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 0.6;
    
    CASpringAnimation *positionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.fromValue = @(self.weekDaysView.layer.position.y);
    positionAnimation.toValue = @(self.weekDaysView.layer.position.y-50);
    positionAnimation.duration = 1;
    positionAnimation.delegate =self;
    positionAnimation.mass =0.8;
    positionAnimation.stiffness = 80;
    positionAnimation.damping = 10;
    positionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[opacityAnimation,positionAnimation];
    [self applyAnimationGroup:group toLayer:self.weekDaysView.layer];
    
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

- (NSMutableArray *)dailyCodeArray{
    if(!_dailyCodeArray){
        _dailyCodeArray = [NSMutableArray array];
    }
    return _dailyCodeArray;
}

- (UIButton *)windButton{
    if(!_windButton){
        _windButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _windButton.alpha = 0;
        _windButton.backgroundColor = [UIColor clearColor];
        _windButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _windButton.titleLabel.textColor = [UIColor whiteColor];
        _windButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_windButton setImage:[UIImage imageNamed:@"windy_day_night"] forState:UIControlStateNormal];
        [_windButton horizontalCenterTitlesAndImages:6];
    }
    return _windButton;
}

- (UIButton *)bodyTmpButton{
    if(!_bodyTmpButton){
        _bodyTmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bodyTmpButton.alpha = 0;
        _bodyTmpButton.backgroundColor = [UIColor clearColor];
        _bodyTmpButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _bodyTmpButton.titleLabel.textColor = [UIColor whiteColor];
        _bodyTmpButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_bodyTmpButton setImage:[UIImage imageNamed:@"tmp"] forState:UIControlStateNormal];
        [_bodyTmpButton horizontalCenterTitlesAndImages:6];
    }
    return _bodyTmpButton;
}

- (UIView *)weekView{
    if(!_weekView){
        _weekView = [[UIView alloc]initWithFrame:CGRectMake(0, 184+56, self.width, 44)];
        _weekView.alpha = 0;
        _weekView.backgroundColor = [UIColor colorWithRGB:@"112A53"];
    }
    return _weekView;
}

- (UIView *)weekDaysView{
    if(!_weekDaysView){
        _weekDaysView = [[UIView alloc]initWithFrame:CGRectMake(0, 184+56, self.width, 44)];
        _weekDaysView.alpha = 0;
        _weekDaysView.backgroundColor = [UIColor clearColor];
    }
    return _weekDaysView;
}

- (NSMutableArray *)weekDays{
    if(!_weekDays){
        _weekDays = [NSMutableArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    }
    return _weekDays;
}

@end
