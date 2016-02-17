//
//  WeatherCityCell.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherCityCell.h"

@interface WeatherCityCell()

@property(nonatomic, strong)UILabel *cityLable;
@property(nonatomic, strong)UIView *lineView;

@end

@implementation WeatherCityCell

#pragma mark - LifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.cityLable];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - Public Method

- (void)setData:(NSString *)data{
    self.cityLable.text = data;
}

#pragma mark - Getters ans Setters

- (UILabel *)cityLable{
    if(!_cityLable){
        _cityLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width, 59)];
        _cityLable.font = [UIFont systemFontOfSize:16];
        _cityLable.textAlignment = NSTextAlignmentLeft;
        _cityLable.textColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1];
     }
    return _cityLable;
}

- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59.5, self.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1];
    }
    return _lineView;
}

@end
