//
//  WeatherView.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/8/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherDataHelper.h"
#import "WeatherBasicInfoView.h"
#import "WeatherDailyForcastView.h"
#import "MenuView.h"



@interface WeatherView()
@property(nonatomic, strong)WeatherBasicInfoView *basicInfoView;
@property(nonatomic, strong)WeatherDailyForcastView *forcastView;
@property(nonatomic, strong)MenuView *menuView;
@property(nonatomic, strong)UIButton *menuButton;

@end

@implementation WeatherView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        [self setupView];

    }
    return self;
}

- (void)setupView{
    [self addSubview:self.basicInfoView];
    [self addSubview:self.forcastView];
    [self addSubview:self.menuView];
    [self addSubview:self.menuButton];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if(flag){
        
        NSString *animName = [anim valueForKey:@"animationName"];
        if([animName isEqualToString:@"bounce"]){
            [self.forcastView completeAnimation];
        }
    }
}

#pragma mark - Public Property

- (void)setModel:(WeatherDataModel *)model{
    _model = model;
    self.basicInfoView.model = [self setBasicInfoModel:model];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:isAnimationOn] isEqualToString:@"YES"]){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.forcastView.y = GlobalScreenHeight;
           [self startBottombounceAnimation];
        self.forcastView.model = [self setDailyForcastModel:model];
    });
    }else{
         self.forcastView.model = [self setDailyForcastModel:model];
    }
}

#pragma mark - Private Methods

- (void)startBottombounceAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 1;
    
    CASpringAnimation *bouncePositionAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    bouncePositionAnimation.fromValue = @(self.forcastView.layer.position.y);
    
        bouncePositionAnimation.toValue = @(self.forcastView.layer.position.y-GlobalScreenHeight*0.42);
    
    bouncePositionAnimation.mass = 1;
    bouncePositionAnimation.stiffness = 70;
    bouncePositionAnimation.damping = 10;
    bouncePositionAnimation.duration = 2;
    bouncePositionAnimation.initialVelocity = 0;
    bouncePositionAnimation.delegate = self;
    [bouncePositionAnimation setValue:@"bounce" forKey:@"animationName"];
    
    bouncePositionAnimation.timingFunction = [CAMediaTimingFunction  functionWithControlPoints:.64 :.57 :.76 :1.72];
    CAAnimationGroup *bounceGroupAnimation = [[CAAnimationGroup alloc]init];
    bounceGroupAnimation.animations = @[bouncePositionAnimation];
    
    [self.forcastView startAnimation:GlobalScreenHeight to:GlobalScreenHeight*0.52];
    [self applyAnimationGroup:bounceGroupAnimation toLayer:self.forcastView.layer];
}



- (WeatherBasicInfoModel *)setBasicInfoModel:(WeatherDataModel *)dataModel{
     WeatherBasicInfoModel *basicInfoModel = [[WeatherBasicInfoModel alloc]init];
    basicInfoModel.code = [[WeatherDataHelper helper]getWeatherIconByCode:dataModel.now.cond.code isDay:YES];
     basicInfoModel.txt = dataModel.now.cond.txt;
     basicInfoModel.city = dataModel.basic.city;
     basicInfoModel.date = [[NSDate date] stringWithFormat:@"yyyy.MM.dd"];
     basicInfoModel.tmp = [NSString stringWithFormat:@"%@°",dataModel.now.tmp];
     basicInfoModel.sunr = ((WeatherDailyModel *)[dataModel.daily_forecast firstObject]).astro.sr;
     basicInfoModel.suns = ((WeatherDailyModel *)[dataModel.daily_forecast firstObject]).astro.ss;
     basicInfoModel.hum =[NSString stringWithFormat:@"%@%%",dataModel.now.hum];
    basicInfoModel.txtWidth = [basicInfoModel.txt widthForFont:[UIFont systemFontOfSize:16]];
    return basicInfoModel;
}

- (WeatherDailyForcastModel *)setDailyForcastModel:(WeatherDataModel *)dataModel{
    WeatherDailyForcastModel *dailyForcastModel = [[WeatherDailyForcastModel alloc]init];
    NSMutableArray *tempForcats = [dataModel.daily_forecast mutableCopy];
    [tempForcats removeObjectAtIndex:0];
    for (int i=0; i< 6 && tempForcats.count; i++) {
        WeatherDailyModel *daily = tempForcats[i];
        WeatherTempTrendModel *trend = [[WeatherTempTrendModel alloc]init];
        trend.code = [[WeatherDataHelper helper] getWeatherIconByCode:daily.cond.code_d isDay:YES];
        trend.highTmp = [daily.tmp.max floatValue];
        trend.lowTmp = [daily.tmp.min floatValue];
        [dailyForcastModel.dailyForcast addObject:trend];
    }
    dailyForcastModel.wind = dataModel.now.wind.dir;
    dailyForcastModel.fl= [NSString stringWithFormat:@"体感%@°",dataModel.now.fl];
    return dailyForcastModel;
}

#pragma mark - Event Response

- (void)click:(UIButton *)btn{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewDidClick)]){
        [self.delegate menuViewDidClick];
    }
}

#pragma mark - Getters and Setters

- (MenuView *)menuView{
    if(!_menuView){
        _menuView = [[MenuView alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    }
    return _menuView;
}


- (UIButton *)menuButton{
    if(!_menuButton){
        _menuButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
        _menuButton.backgroundColor = [UIColor clearColor];
        [_menuButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (WeatherBasicInfoView *)basicInfoView{
    if(!_basicInfoView){
        _basicInfoView = [[WeatherBasicInfoView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height*0.58)];
    }
    return  _basicInfoView;
}

- (WeatherDailyForcastView *)forcastView{
    if(!_forcastView){
        
        _forcastView = [[WeatherDailyForcastView alloc]initWithFrame:CGRectMake(0, self.height*0.58, self.width, self.height*0.42)];
    }
    return _forcastView;
}
@end
