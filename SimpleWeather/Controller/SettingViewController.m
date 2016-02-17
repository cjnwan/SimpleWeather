//
//  SettingViewController.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/13/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "SettingViewController.h"

#import "SettingDataHelper.h"
#import "SettingCell.h"
#import "SCLAlertView.h"

@interface SettingViewController()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@property(nonatomic, copy)NSString *isPush;
@property(nonatomic, copy)NSString *isAnimate;

@end
@implementation SettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad{
    [self setupView];
    [self setupData];
}

- (void)setupView{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeClick:)];
    self.navigationItem.title = @"设置";
   
    [self.view addSubview:self.tableView];
}

- (void)setupData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.isPush = [user objectForKey:isPushOn];
    self.isAnimate = [user objectForKey:isAnimationOn];
}

#pragma mark - UITableViewDataSouerce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell  *cell;
    if(indexPath.section == 0){
        cell = [[SettingCell alloc]initWithType:SettingItemTypeChoose andBottomLine:NO];
        cell.titleLabel.text = @"推送通知";
        [cell.chooseSwitch setOn:([self.isPush isEqualToString:@"YES"]?YES:NO)];
        cell.chooseSwitch.tag = 0;
        [cell.chooseSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }else if(indexPath.section == 1){
        cell = [[SettingCell alloc]initWithType:SettingItemTypeChoose andBottomLine:NO];
        [cell.chooseSwitch setOn:([self.isAnimate isEqualToString:@"YES"]?YES:NO)];
        cell.chooseSwitch.tag = 1;
        [cell.chooseSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.titleLabel.text = @"天气动画";
    }else if(indexPath.section == 2){
        if(indexPath.row==2){
            cell = [[SettingCell alloc]initWithType:SettingItemTypeContent andBottomLine:NO];
            cell.titleLabel.text = @"意见反馈";
            cell.contentLabel.text = @"QQ群号：115391637";
        }else if(indexPath.row == 1){
             cell = [[SettingCell alloc]initWithType:SettingItemTypeDefault andBottomLine:YES];
             cell.titleLabel.text = @"给个好评";
        }else if(indexPath.row == 0){
            cell = [[SettingCell alloc]initWithType:SettingItemTypeContent andBottomLine:YES];
            cell.titleLabel.text = @"版本";
            cell.contentLabel.text = @"1.0";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 1){
        NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"1075823384"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 1){
        
        return  YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FotterView"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"FotterView"];
        [view setBackgroundView:[UIView new]];
    }
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderView"];
        [view setBackgroundView:[UIView new]];
    }
    return view;
}


#pragma mark - Event Response

- (void)completeClick:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchAction:(UISwitch *)chooseSwitch{
    if(chooseSwitch.tag == 0){
        
        UIUserNotificationType type =  [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if(type == UIUserNotificationTypeNone){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            alert.backgroundType = Blur;
            
            [alert showNotice:self title:@"提示" subTitle:@"您已经关闭推送服务，需要在设置－通知中打开" closeButtonTitle:@"确定" duration:0.0f];
            [chooseSwitch setOn:NO];
            return;
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSString stringWithFormat:@"%@",chooseSwitch.isOn?@"YES":@"NO"] forKey:isPushOn];
        [user synchronize];
        if(chooseSwitch.isOn == NO){
            [[UIApplication sharedApplication]cancelAllLocalNotifications];
        }else{
            
        }
    }else if(chooseSwitch.tag == 1){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSString stringWithFormat:@"%@",chooseSwitch.isOn?@"YES":@"NO"] forKey:isAnimationOn];
        [user synchronize];
    }
}

#pragma mark - Getters and Setters

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
