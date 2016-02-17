//
//  WeatherForcastCell.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "WeatherForcastCell.h"


@interface WeatherForcastCell()

@property(nonatomic, strong)UIImageView *weatherImageView;
@property(nonatomic, strong)UILabel *addressView;
@property(nonatomic, strong)UILabel *tmpView;
@property(nonatomic, strong)UIView *lineView;

@end


#pragma mark - LifeCycle
@implementation WeatherForcastCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.weatherImageView];
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.tmpView];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - Public Property

- (void)setModel:(WeatherCacheModel *)model{
    self.weatherImageView.image =[UIImage imageNamed:model.cond];
    self.addressView.text = model.cityName;
    self.tmpView.text =[NSString stringWithFormat:@"%@C",model.temp];
}

#pragma mark - Getters and Setters

- (UIImageView *)weatherImageView{
    if(!_weatherImageView){
        _weatherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 36, 36)];
        _weatherImageView.backgroundColor = kThemeColor;
        _weatherImageView.layer.cornerRadius = 18;
    }
    return _weatherImageView;
}

- (UILabel *)addressView{
    if(!_addressView){
        _addressView = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.width-60-130, 52)];
        _addressView.font = [UIFont systemFontOfSize:16];
        _addressView.textAlignment = NSTextAlignmentLeft;
        _addressView.textColor = [UIColor colorWithRed:0.48 green:0.50 blue:0.56 alpha:1];

    }
    return _addressView;
}

- (UILabel *)tmpView{
    if(!_tmpView){
        if(iPhone5s){
            _tmpView = [[UILabel alloc]initWithFrame:CGRectMake(self.width-130, 0, 50, 52)];

        }else{
          _tmpView = [[UILabel alloc]initWithFrame:CGRectMake(self.width-60, 0, 50, 52)];
        }
        _tmpView.textAlignment = NSTextAlignmentRight;
        _tmpView.font = [UIFont systemFontOfSize:16];
        _tmpView.textColor = [UIColor colorWithRed:0.48 green:0.50 blue:0.56 alpha:1];
    }
    return _tmpView;
}

- (UIView *)lineView{
    if(!_lineView){
        _lineView  = [[UIView alloc]initWithFrame:CGRectMake(6, 51.5, self.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    }
    return _lineView;
}

@end
