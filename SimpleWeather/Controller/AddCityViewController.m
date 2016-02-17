//
//  AddCityViewController.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/7/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "AddCityViewController.h"
#import "CityDatabaseManager.h"
#import "CityFMDatabaseQueue.h"
#import "WeatherCityCell.h"
#import "WeatherDatabaseManager.h"
#import "CitySearchBarController.h"
#import "SCLAlertView.h"

@interface AddCityViewController()<UITableViewDataSource,UITableViewDelegate,CitySearchBarControllerDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)NSMutableArray *filteredDataSource;
@property(nonatomic, assign)BOOL shouldShowSearchResults;
@property(nonatomic, strong)CitySearchBarController *citySearchController;
@property(nonatomic, strong)NSArray *CommonData;
@end

@implementation AddCityViewController

- (void)viewDidLoad{
    [self setupView];
    
    [self setupSearchController];
    
    [self setupData];
   
}

- (void)setupData{
     self.dataSource = [self.CommonData copy];
    [self.tableView reloadData];
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
}


- (void)setupView{
    [self.view addSubview:self.tableView];
}

- (void)setupSearchController{
    _citySearchController = [[CitySearchBarController alloc]initWithSearchVC:self searchBarFrame:CGRectMake(0.0, 0.0, self.view.width, 50.0) Font:[UIFont fontWithName:@"Futura" size:16] textColor:[UIColor whiteColor] tintColor:kThemeColor];
    _citySearchController.citySearchBar.placeholder = @"请输入你要搜索的城市名称";
    _citySearchController.delegate = self;
    self.tableView.tableHeaderView = _citySearchController.citySearchBar;
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.shouldShowSearchResults){
        return self.filteredDataSource.count;
    }else{
        return self.dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeatherCityCell *cell = [[WeatherCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if(self.shouldShowSearchResults){
         [cell setData:self.filteredDataSource[indexPath.row]];
    }else{
         [cell setData:self.dataSource[indexPath.row]];
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    return cell;
}

#pragma mark - CitySearchBarControllerDelegate

- (void)didStartSearching{
    self.shouldShowSearchResults = YES;
    [self.tableView reloadData];
}

-(void)didTapOnSearchButton{
    if(!self.shouldShowSearchResults){
        self.shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
}

-(void)didTapOnCancelButton{
    if(!self.shouldShowSearchResults){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.citySearchController.citySearchBar.text = @"";
        self.shouldShowSearchResults = NO;
        [self.tableView reloadData];
    }
}

- (void)didChangeSearchText:(NSString *)searchText{
    
    CityDatabaseManager *data = [CityDatabaseManager manager];
    NSMutableArray *date = [data getCityNameBySearchKey:searchText];
    self.filteredDataSource = [date mutableCopy];
    [self.tableView reloadData];

    
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCity:)]){
        
        [self.citySearchController.citySearchBar resignFirstResponder];
        if(self.shouldShowSearchResults){
            NSString *cityName = self.filteredDataSource[indexPath.row];
            if([[WeatherDatabaseManager manager]DBWeatherIsExistModelByCityKey:cityName]){
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                
                [alert showWarning:self title:@"警告" subTitle:@"您已经添加过该城市，请不要在添加" closeButtonTitle:@"关闭" duration:0.0f];

            }else{
                [self.delegate didSelectCity:cityName];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            NSString *cityName = self.dataSource[indexPath.row];
            if([[WeatherDatabaseManager manager]DBWeatherIsExistModelByCityKey:cityName]){
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                
                 [alert showWarning:self title:@"警告" subTitle:@"您已经添加过该城市，请不要在添加" closeButtonTitle:@"关闭" duration:0.0f];

            }else{
                [self.delegate didSelectCity:cityName];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    }
}


#pragma mark - Getters ans Setters

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WeatherCityCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)filteredDataSource{
    if(!_filteredDataSource){
        _filteredDataSource = [NSMutableArray array];
    }
    return _filteredDataSource;
}

- (NSArray *)CommonData{
    
    NSArray *data = @[@"北京",@"天津",@"上海",@"重庆",@"沈阳",@"大连",@"长春",@"哈尔滨",@"武汉",@"长沙",@"广州",@"深圳",@"南京"];
    return data;
}

@end
