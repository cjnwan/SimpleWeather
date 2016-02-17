//
//  SettingCell.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

#pragma mark - LifeCycle

- (instancetype)initWithType:(SettingItemType)type andBottomLine:(BOOL)addLine{
    if(self = [super init]){
        if(type == SettingItemTypeContent){
            [self addSubview:self.contentLabel];
        }else if(type ==SettingItemTypeChoose){
            [self addSubview:self.chooseSwitch];
        }
        [self addSubview:self.titleLabel];
        if(addLine){
        [self addSubview:self.lineView];
        }
        
    }
    return self;
}


#pragma mark - Getters and Setters

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 43)];;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(GlobalScreenWidth-200-40, 0, 200, 43)];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _contentLabel;
}

- (UISwitch *)chooseSwitch{
    if(!_chooseSwitch){
        _chooseSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(GlobalScreenWidth-50-10, 6, 50, 43)];
    }
    return _chooseSwitch;
}

- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 42.5, GlobalScreenWidth-10, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255  blue:188.0/255 alpha:0.6f];
    }
    return _lineView;
}

@end
