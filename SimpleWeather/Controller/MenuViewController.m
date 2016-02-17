//
//  MenuViewController.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/11/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "MenuViewController.h"
#import "WeatherForcastCell.h"
#import "AddCityViewController.h"
#import "ViewController.h"
#import "WeatherDatabaseManager.h"
#import "WeatherDataHelper.h"
    #import "SettingViewController.h"

@interface MenuViewController()<UITableViewDataSource,UITableViewDelegate,AddCityDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)UIView *settingView;
@property(nonatomic, strong)UILabel *settingLabel;
@property(nonatomic, strong)UIButton *settingButton;
@property(nonatomic, strong)AddCityViewController *addCityVC;

@end

@implementation MenuViewController


#pragma mark - LifeCycle

- (void)viewDidLoad{
    
    [super viewDidLoad];

    [self setupView];
    
    [self setupData];
    
    [self setupNotification];
}

- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick:)];
   UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addClick:)];
    
    UIBarButtonItem *positionBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(addClick:)];
    
    self.navigationItem.rightBarButtonItems = iPhone5s?@[positionBtn,positionBtn,rightBtn]: @[rightBtn];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.settingView];
    [self.settingView addSubview:self.settingLabel];
    [self.settingView addSubview:self.settingButton];
}

- (void)setupData{
    
    NSArray *dataSource = [[WeatherDatabaseManager manager] DBWeatherGETAllModels];

    self.dataSource = [dataSource mutableCopy];
    [self.tableView reloadData];
}

- (void)dealloc{
    [self removeNotification];
}

- (void)setupNotification{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(refreshData:) name:@"refreshCityData" object:nil];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCityData" object:nil];
}

#pragma mark - Notification

- (void)refreshData:(NSNotification *)notification{
    WeatherDataModel *dataModel = (WeatherDataModel *)[notification object];
    
    for (int i=0; i<self.dataSource.count; i++) {
        WeatherCacheModel *model = self.dataSource[i];
        if([model.cityName isEqualToString:dataModel.basic.city]){
            return;
        }
    }
    WeatherCacheModel *cacheModel = [[WeatherCacheModel alloc]init];
    cacheModel.cond = [[WeatherDataHelper helper]getWeatherIconByCode:dataModel.now.cond.code isDay:YES];
    cacheModel.temp = [NSString stringWithFormat:@"%@°",dataModel.now.tmp];
    cacheModel.cityName = dataModel.basic.city;
    [self.dataSource addObject:cacheModel];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeatherForcastCell *cell = [[WeatherForcastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setModel:self.dataSource[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewConroller:weatherRemoveOperation:)]){
        [self.delegate viewConroller:self weatherSelectOperation:indexPath.row];
    }
    [self.revealViewController revealToggle:nil];
    [self RestoreToOriginalState];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        WeatherCacheModel *cacheModel = (WeatherCacheModel *)self.dataSource[indexPath.row];
        [[WeatherDatabaseManager manager] DBWeatherDeleteModel:cacheModel.cityName];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewConroller:weatherRemoveOperation:)]){
            [self.delegate viewConroller:self weatherRemoveOperation:indexPath.row];
        }
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    }
    
}

#pragma mark - AddCityDelegate

- (void)didSelectCity:(NSString *)city{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewConroller:weatherAddOperation:)]){
        [self.delegate viewConroller:self weatherAddOperation:city];
    }
    [self RestoreToOriginalState];
    [self.revealViewController revealToggle:nil];
    
}

#pragma mark - Event Response

- (void)editClick:(UIBarButtonItem *)button{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

- (void)addClick:(UIBarButtonItem *)button{
    self.addCityVC= [[AddCityViewController alloc]init];
    self.addCityVC.delegate = self;
    [self.navigationController presentViewController:self.addCityVC animated:YES completion:nil];
   
}

- (void)gotoSetting:(UIButton *)btn{
    SettingViewController *svc = [[SettingViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:svc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)RestoreToOriginalState{
    if(self.tableView.isEditing){
        [self.tableView setEditing:NO];
    }
}

#pragma mark - Getters and Setters

- (UITableView *)tableView{
    if(!_tableView){
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-50, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WeatherForcastCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)settingView{
    if(!_settingView){
        _settingView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-49, self.view.width, 49)];
        _settingView.backgroundColor = kThemeColor;
    }
    return _settingView;
}

- (UILabel *)settingLabel{
    if(!_settingLabel){
        _settingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 49)];
        _settingLabel.text = NSTextAlignmentLeft;
        _settingLabel.textColor = [UIColor whiteColor];
        _settingLabel.font = [UIFont systemFontOfSize:16];
        _settingLabel.text = @"设置";
    }
    return _settingLabel;
}

- (UIButton *)settingButton{
    if(!_settingButton){
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(0, 0, self.view.width, 49);
        [_settingButton addTarget:self action:@selector(gotoSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

@end
