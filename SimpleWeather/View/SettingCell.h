//
//  SettingCell.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SettingItemType){
    SettingItemTypeDefault,//title,arrow
    SettingItemTypeChoose,//title,check
    SettingItemTypeContent//title,text
};

@interface SettingCell : UITableViewCell

- (instancetype)initWithType:(SettingItemType)type andBottomLine:(BOOL)addLine;

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UISwitch *chooseSwitch;
@property(nonatomic, strong)UIView *lineView;

@end
