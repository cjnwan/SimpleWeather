//
//  WeatherBasicInfoView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherBasicInfoView.h"
#import "MenuView.h"


@interface WeatherBasicInfoView()

@property(nonatomic, strong)UIView *condView;
@property(nonatomic, strong)UIImageView *condImage;
@property(nonatomic, strong)UILabel *condLabel;

@property(nonatomic, strong)UILabel *cityLabel;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UILabel *tempLabel;

@property(nonatomic, strong)UIButton *humButton;
@property(nonatomic, strong)UIButton *sunRButton;
@property(nonatomic, strong)UIButton *sunSButton;

@end

@implementation WeatherBasicInfoView

#pragma mark -LifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];;
        [self setupView];
        [self setupPosition];
        
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.condView];
    [self addSubview:self.condImage];
    [self addSubview:self.condLabel];
    [self addSubview:self.cityLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.tempLabel];
    [self addSubview:self.sunRButton];
    [self addSubview:self.humButton];
    [self addSubview:self.sunSButton];
}

- (void)setupPosition{
    self.condView.frame = CGRectMake(self.width-30-20, 30, 30, 30);
    self.condImage.frame = CGRectMake(self.width-30-20, 30, 30, 30);
    self.cityLabel.frame  = CGRectMake(0, 100, self.width, 34);
    self.dateLabel.frame = CGRectMake(0, 140, self.width, 20);
    self.tempLabel.frame = CGRectMake(0, 160, self.width, 90);
    self.sunRButton.frame = CGRectMake(20, 270, 80, 30);
    self.humButton.frame = CGRectMake(self.centerX-40, 270, 80, 30);
    self.sunSButton.frame = CGRectMake(self.width-80-20, 270, 80, 30);
}

#pragma mark - Public Opacity

- (void)setModel:(WeatherBasicInfoModel *)model{
    _model = model;
    self.condLabel.frame = CGRectMake(self.width-20, 30, model.txtWidth, 30);
    self.condImage.image =[UIImage imageNamed:model.code];
    self.condLabel.text = model.txt;
    self.cityLabel.text = model.city;
    self.dateLabel.text = model.date;
    self.tempLabel.text = model.tmp;
    [self.sunRButton setTitle:model.sunr forState:UIControlStateNormal];
    [self.sunSButton setTitle:model.suns forState:UIControlStateNormal];
    [self.humButton setTitle:model.hum forState:UIControlStateNormal];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isAnimationOn] isEqualToString:@"YES"]){
     [self initOriginalState];
     [self startAnimation];
    }else{
        self.condView.frame = CGRectMake(self.width-30-20-_model.txtWidth-16, 30, _model.txtWidth+self.condView.width+16, 30);
        self.condImage.frame = CGRectMake(self.width-30-20-model.txtWidth-10, 30, 30, 30);
        self.condLabel.frame = CGRectMake(self.width-20-model.txtWidth-5, 30, model.txtWidth, 30);
    }
}

- (void)initOriginalState{
    self.condView.alpha = 0;
    self.condView.transform = CGAffineTransformMakeScale(0, 0);
    self.condImage.alpha = 0;
    self.condImage.transform = CGAffineTransformMakeScale(0, 0);
    self.condLabel.alpha = 0;
    
    self.cityLabel.alpha = 0;
    self.dateLabel.alpha = 0;
    self.tempLabel.alpha = 0;
    self.cityLabel.transform = CGAffineTransformMakeTranslation(0, 40);
    self.dateLabel.transform = CGAffineTransformMakeTranslation(0, 40);
    self.tempLabel.transform = CGAffineTransformMakeTranslation(0, 40);
    
    self.sunRButton.alpha = 0;
    self.humButton.alpha = 0;
    self.sunSButton.alpha = 0;
    self.sunRButton.transform = CGAffineTransformMakeTranslation(0, 30);
    self.humButton.transform = CGAffineTransformMakeTranslation(0, 30);
    self.sunSButton.transform = CGAffineTransformMakeTranslation(0, 30);
}

- (void)startAnimation{
    [self startCondAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startBasicAnimation];
            [self startAstroAnimation];
        });
}

- (void)startCondAnimation{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.delegate = self;
    rotationAnimation.cumulative = YES;
    [rotationAnimation setValue:@"condRotateAnimation" forKey:@"animationName"];
    rotationAnimation.duration = 1;
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(1);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[scaleAnimation,opacityAnimation];
    group.duration = 0.6;
    
    [self.condView applyAnimationGroup:group toLayer:self.condView.layer];
    [self.condImage applyAnimationGroup:group toLayer:self.condImage.layer];
    [self.condImage applyBasicAnimation:rotationAnimation toLayer:self.condImage.layer];
    
}

- (void)startCondPositionAnimation{
    
    CABasicAnimation *condBoundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    condBoundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _model.txtWidth+self.condView.width+16, 30)];
    
    CABasicAnimation *condPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    condPositionAnimation.fromValue = @(self.condView.layer.position.x);
    condPositionAnimation.toValue = @(self.condView.layer.position.x-_model.txtWidth/2-8);
    
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[condPositionAnimation,condBoundsAnimation];
    group.duration = 0.6;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self applyAnimationGroup:group toLayer:self.condView.layer];
    
    
    
    CASpringAnimation *codePositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.x"];
    codePositionAnimation.fromValue =@(self.condImage.layer.position.x);
    codePositionAnimation.toValue = @(self.condImage.layer.position.x-_model.txtWidth-10);
    codePositionAnimation.mass = 1;
    codePositionAnimation.stiffness = 80;
    codePositionAnimation.damping = 10;
    codePositionAnimation.duration = 0.8;
    
    codePositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.76 :1.72];
    [self applyBasicAnimation:codePositionAnimation toLayer:self.condImage.layer];
    
    CABasicAnimation *txtOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    txtOpacityAnimation.toValue = @(1);
    txtOpacityAnimation.duration = 0.5;
    txtOpacityAnimation.duration = 0.6;
    
    
    
    CASpringAnimation *txtPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.x"];
    txtPositionAnimation.fromValue = @(self.condLabel.layer.position.x);
    txtPositionAnimation.toValue = @(self.condLabel.layer.position.x-_model.txtWidth-8);
    txtPositionAnimation.mass = 1;
    txtPositionAnimation.stiffness = 100;
    txtPositionAnimation.damping = 10;
    txtPositionAnimation.duration = 0.8;
    txtPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.76 :1.72];
    [txtPositionAnimation setValue:@"txtPositionAnimation" forKey:@"animationName"];
    
    CAAnimationGroup *txtGroup = [[CAAnimationGroup alloc]init];
    txtGroup.animations = @[txtOpacityAnimation,txtPositionAnimation];
    
    [self applyAnimationGroup:txtGroup toLayer:self.condLabel.layer];

}

- (void)startBasicAnimation{
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation  animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 0.3;
    
    CASpringAnimation *cityPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    cityPositionAnimation.fromValue = @(self.cityLabel.layer.position.y);
    cityPositionAnimation.toValue = @(self.cityLabel.layer.position.y-60);
    cityPositionAnimation.mass = 1;
    cityPositionAnimation.stiffness = 100;
    cityPositionAnimation.initialVelocity = 0;
    cityPositionAnimation.damping = 10;
    cityPositionAnimation.duration = 2.9;
    cityPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *cityGroupAnimation = [[CAAnimationGroup alloc]init];
    cityGroupAnimation.animations = @[opacityAnimation,cityPositionAnimation];
    [self applyAnimationGroup:cityGroupAnimation toLayer:self.cityLabel.layer];
    
    
    CASpringAnimation *datePositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    datePositionAnimation.fromValue =@(self.dateLabel.layer.position.y);
    datePositionAnimation.toValue = @(self.dateLabel.layer.position.y-60);
    datePositionAnimation.mass = 1;
    datePositionAnimation.duration = 1;
    datePositionAnimation.stiffness = 100;
    datePositionAnimation.initialVelocity = 0;
    datePositionAnimation.damping = 10;
    datePositionAnimation.duration = 2.9;
    datePositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    
    CAAnimationGroup *dateGroupAnimation = [[CAAnimationGroup alloc]init];
    dateGroupAnimation.animations = @[opacityAnimation,datePositionAnimation];
    [self applyAnimationGroup:dateGroupAnimation toLayer:self.dateLabel.layer];
    
    
    CASpringAnimation *tmpPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    tmpPositionAnimation.fromValue =@(self.tempLabel.layer.position.y);
    tmpPositionAnimation.toValue = @(self.tempLabel.layer.position.y-60);
    tmpPositionAnimation.mass = 1;
    tmpPositionAnimation.duration = 1;
    tmpPositionAnimation.stiffness = 100;
    tmpPositionAnimation.initialVelocity = 0;
    tmpPositionAnimation.damping = 10;
    tmpPositionAnimation.duration = 2.9;
    tmpPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *tmpGroupAnimation = [[CAAnimationGroup alloc]init];
    tmpGroupAnimation.animations = @[opacityAnimation,tmpPositionAnimation];
    [self applyAnimationGroup:tmpGroupAnimation toLayer:self.tempLabel.layer];
}

- (void)startAstroAnimation{
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 0.6;
    
    CASpringAnimation *sunrisePositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    sunrisePositionAnimation.fromValue = @(self.sunRButton.layer.position.y);
    sunrisePositionAnimation.toValue = @(self.sunRButton.layer.position.y-40);
    sunrisePositionAnimation.mass = 1;
    sunrisePositionAnimation.stiffness = 100;
    sunrisePositionAnimation.damping = 10;
    sunrisePositionAnimation.duration = 3.5;
    sunrisePositionAnimation.initialVelocity = 0;
    
    sunrisePositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    CAAnimationGroup *sunrisepGroupAnimation = [[CAAnimationGroup alloc]init];
    sunrisepGroupAnimation.animations = @[opacityAnimation,sunrisePositionAnimation];
    
    
    CASpringAnimation *humlityPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    humlityPositionAnimation.fromValue = @(self.sunSButton.layer.position.y);
    humlityPositionAnimation.toValue = @(self.sunSButton.layer.position.y-40);
    humlityPositionAnimation.mass = 1;
    humlityPositionAnimation.stiffness = 100;
    humlityPositionAnimation.damping = 10;
    humlityPositionAnimation.duration = 4.5;
    humlityPositionAnimation.initialVelocity = 0;
    humlityPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *humlityGroupAnimation = [[CAAnimationGroup alloc]init];
    humlityGroupAnimation.animations = @[opacityAnimation,humlityPositionAnimation];
    
    CASpringAnimation *sunsetPositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    sunsetPositionAnimation.fromValue = @(self.sunSButton.layer.position.y);
    sunsetPositionAnimation.toValue = @(self.sunSButton.layer.position.y-40);
    sunsetPositionAnimation.mass = 1;
    sunsetPositionAnimation.stiffness = 100;
    sunsetPositionAnimation.damping = 10;
    sunsetPositionAnimation.duration = 4.5;
    sunsetPositionAnimation.initialVelocity = 0;
    sunsetPositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.67 :1.53];
    
    CAAnimationGroup *sunsetpGroupAnimation = [[CAAnimationGroup alloc]init];
    sunsetpGroupAnimation.animations = @[opacityAnimation,sunsetPositionAnimation];
    
    
    [self applyAnimationGroup:sunrisepGroupAnimation toLayer:self.sunRButton.layer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self applyAnimationGroup:humlityGroupAnimation toLayer:self.humButton.layer];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self applyAnimationGroup:sunsetpGroupAnimation toLayer:self.sunSButton.layer];
    });
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if(flag){
        
        NSString *animName = [anim valueForKey:@"animationName"];
        
        if([animName isEqualToString:@"condRotateAnimation"]){
            
            [self startCondPositionAnimation];
        }
    }
}


#pragma mark - Getters and Setters
- (UIView *)condView{
    if(!_condView){
        _condView = [[UIView alloc]init];
        _condView.layer.cornerRadius = 15;
        _condView.backgroundColor = [UIColor colorWithRGB:@"0x122f52"];
    }
    return _condView;
}

-(UIImageView *)condImage{
    if(!_condImage){
        _condImage = [[UIImageView alloc]init];
    }
    return _condImage;
}

- (UILabel *)condLabel{
    if(!_condLabel){
        _condLabel = [[UILabel alloc]init];
        _condLabel.textAlignment = NSTextAlignmentCenter;
        _condLabel.font = [UIFont systemFontOfSize:14];
        _condLabel.textColor = [UIColor colorWithRed:0.32 green:0.66 blue:0.84 alpha:1];
    }
    return _condLabel;
}

- (UILabel *)cityLabel{
    if(!_cityLabel){
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.font = [UIFont systemFontOfSize:32];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cityLabel;
}

- (UILabel *)dateLabel{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:16];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UILabel *)tempLabel{
    if(!_tempLabel){
        _tempLabel = [[UILabel alloc]init];
        _tempLabel.font = [UIFont systemFontOfSize:82];
        _tempLabel.textColor = [UIColor whiteColor];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tempLabel;
}

- (UIButton *)humButton{
    if(!_humButton){
        _humButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _humButton.backgroundColor = [UIColor clearColor];
        _humButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _humButton.titleLabel.textColor = [UIColor whiteColor];
        [_humButton setImage:[UIImage imageNamed:@"humlity"] forState:UIControlStateNormal];
        [_humButton horizontalCenterTitlesAndImages:6];
    }
    return _humButton;
}

- (UIButton *)sunRButton{
    if(!_sunRButton){
        _sunRButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sunRButton.backgroundColor = [UIColor clearColor];
        _sunRButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sunRButton.titleLabel.textColor = [UIColor whiteColor];
        _sunRButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_sunRButton setImage:[UIImage imageNamed:@"weather_sunrise"] forState:UIControlStateNormal];
        [_sunRButton horizontalCenterTitlesAndImages:6];
    }
    return _sunRButton;
}

- (UIButton *)sunSButton{
    if(!_sunSButton){
        _sunSButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sunSButton.backgroundColor = [UIColor clearColor];
        _sunSButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sunSButton.titleLabel.textColor = [UIColor whiteColor];
        _sunRButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_sunSButton setImage:[UIImage imageNamed:@"weather_sunset"] forState:UIControlStateNormal];
        [_sunSButton horizontalCenterTitlesAndImages:6];
    }
    return _sunSButton;
}

@end
