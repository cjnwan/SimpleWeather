//
//  ViewController.m
//  SimpleWeather
//
//  Created by 陈剑南 on 11/30/15.
//  Copyright © 2015 Jimmy Chen. All rights reserved.
//

#import "ViewController.h"
#import "SwipeView.h"
#import "WeatherView.h"
#import "HttpManager.h"
#import "ModalPresentAnimation.h"
#import "ModalDismissAnimation.h"
#import "PanInteractiveTransition.h"
#import "AddCityViewController.h"
#import "SimpleWeather-Swift.h"
#import "WeatherBasicInfoView.h"
#import "MenuViewController.h"
#import "WeatherLocationHelper.h"
#import "WeatherDatabaseManager.h"
#import "SCLAlertView.h"

@interface ViewController()<SwipeViewDataSource,SwipeViewDelegate,WeatherMenuDelegate,SWRevealViewControllerDelegate,WeatherLocationDelegate,WeatherOperationDeleaget>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)SwipeView *swipView;
@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *cityArray;
@property(nonatomic, strong)NSString *isFirstTime;
@property(nonatomic, strong)WeatherView *currentWeatherView;
@property(nonatomic, strong)SCLAlertView *waitingAlert;

@property(nonatomic, strong)SWRevealViewController *revealVC;

@property(nonatomic, strong)ModalPresentAnimation *presentAnimation;
@property(nonatomic, strong)ModalDismissAnimation *dismissAnimation;
@property(nonatomic, strong)PanInteractiveTransition *interactiveTransition;


@end

#pragma mark -LifeCycle

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupData];
   
}

- (void)setupView{
    
    self.revealVC = [self revealViewController];
    
    self.revealVC.delegate = self;

    self.view.backgroundColor = kThemeColor;
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.swipView];
    
    [self setupPullToRefreshView:self.scrollView];
}

- (void)setupPullToRefreshView:(UIScrollView *)scrollView{
    
    DGElasticPullToRefreshLoadingViewCircle *cycle = [[DGElasticPullToRefreshLoadingViewCircle alloc]init];
    
    cycle.tintColor = [UIColor colorWithRed:0.29 green:0.77 blue:0.97 alpha:1.0];
    
    [scrollView dg_addPullToRefreshWithActionHandler:^{
         [scrollView dg_stopLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshCurrentViewData];
        });
        
    } loadingView:cycle];
    
    [scrollView dg_setPullToRefreshFillColor:[UIColor colorWithRed:0.06 green:0.2 blue:0.35 alpha:1]];
    
    [scrollView dg_setPullToRefreshBackgroundColor:kThemeColor];
}

- (void)setupData{
    NSMutableArray *cityArray = [[WeatherDatabaseManager manager] DBWeatherGetAllCitys];
    if(cityArray.count == 0){
        WeatherLocationHelper *helper = [WeatherLocationHelper helper];
        helper.delegate = self;
        helper.isFirstTime = YES;
        [helper startLocation];
    }else{
        self.cityArray = [cityArray mutableCopy];
        [self setupDataAllCity];
        
        WeatherLocationHelper *helper = [WeatherLocationHelper helper];
        helper.delegate = self;
        helper.isFirstTime = NO;
    }
}

- (void)setupDataAllCity{
    [self showWaitingView];
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpManager *httpManager = [HttpManager manager];
        [httpManager getWeatherDataByCityNames:self.cityArray dataHandle:^(NSArray * _Nonnull dataModels) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i=0; i<self.cityArray.count; i++){
                    NSString *cityName = self.cityArray[i];
                    for(int i= 0; i<dataModels.count; i++){
                        WeatherDataModel *dataModel =  dataModels[i];
                        if([cityName isEqualToString: dataModel.basic.city]){
                            [weakSelf.dataSource addObject:dataModel];
                        }
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.waitingAlert hideView];
                    [weakSelf.swipView reloadData];
                });
                
            });
            
        }];
    });
}

- (void)showWaitingView{
     self.waitingAlert= [[SCLAlertView alloc] init];
    
    self.waitingAlert.showAnimationType = SlideInToCenter;
    self.waitingAlert.hideAnimationType = SlideOutFromCenter;
    
    
    self.waitingAlert.backgroundType = Transparent;
    
    [self.waitingAlert showWaiting:self title:@"等待..."
              subTitle:@"正在获取天气数据，请耐心等待"
      closeButtonTitle:nil duration:15.0f];

}

- (void)setupDataFirstCity:(NSString *)cityName isNeedPost:(BOOL)needPost{
    
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpManager *httpManager = [HttpManager manager];
        [httpManager getWeatherDataByCityName:cityName dataHandle:^(WeatherDataModel * _Nonnull dataModel) {
            [weakSelf.dataSource addObject:dataModel];
            if(self.waitingAlert){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.waitingAlert hideView];
                });
               
            }
            [weakSelf.swipView reloadData];
            [weakSelf.swipView scrollToItemAtIndex:weakSelf.dataSource.count duration:0];
            if(needPost){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCityData" object:dataModel];
            }
        }];
    });
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - SWRevealViewControllerDelegate

-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    FrontViewPosition fp;
    if(iPhone5s){
        fp = FrontViewPositionRight;
    }else{
        fp = FrontViewPositionRightMost;
    }
    if (revealController.frontViewPosition == fp) {
        UIView *lockingView = [[UIView alloc] initWithFrame:revealController.frontViewController.view.frame];
        lockingView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
        [lockingView addGestureRecognizer:tap];
        [lockingView setTag:1000];
        [revealController.frontViewController.view addSubview:lockingView];
    }
    else
        [[revealController.frontViewController.view viewWithTag:1000] removeFromSuperview];
    
}

#pragma mark - WeatherLocationDelegate


- (void)weatherLocation:(WeatherLocationHelper *)helper didSuccess:(NSString *)cityName{
    
    if(cityName.length>0){
        [self showWaitingView];
        [self setupDataFirstCity:cityName isNeedPost:YES];
    }
}

- (void)weatherLocation:(WeatherLocationHelper *)helper didFailed:(NSError *)error{
    
    NSLog(@"位置信息获取失败");
}

- (void)weatherLocationDidClose:(WeatherLocationHelper *)helper{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    alert.backgroundType = Blur;
    
    [alert showNotice:self title:@"提示" subTitle:@"您已经关闭定位服务，需要在设置－隐私－定位服务中打开" closeButtonTitle:@"确定" duration:0.0f];
    
    NSLog(@"定位失败");
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [self.dataSource count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    WeatherView *weatherView = [[WeatherView alloc] initWithFrame:self.swipView.bounds];
    [weatherView setModel:(WeatherDataModel *)self.dataSource[index]];
    weatherView.delegate = self;
    return weatherView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    return self.swipView.bounds.size;
}


#pragma mark - WeatherOperationDeleaget

- (void)viewConroller:(ViewController *)viewController weatherAddOperation:(NSString *)cityName{
    if(cityName.length>0){
         [self setupDataFirstCity:cityName isNeedPost:YES];
    }
}

- (void)viewConroller:(ViewController *)viewController weatherRemoveOperation:(NSInteger)index{
    
    if(index>=0 && index<self.dataSource.count){
        [self.dataSource removeObjectAtIndex:index];
        [self.swipView reloadData];
    }
}

- (void)viewConroller:(MenuViewController *)viewController weatherSelectOperation:(NSInteger)index{
    [self.swipView scrollToItemAtIndex:index duration:0];
}


#pragma mark - Event Response

- (void)menuViewDidClick{
    
    [self.revealVC setFrontViewPosition:iPhone5s?FrontViewPositionRight:FrontViewPositionRightMost animated:YES];
    
}

#pragma mark - Private Method

- (void)refreshCurrentViewData{
    if(self.dataSource.count==0){
        NSMutableArray *data = [[WeatherDatabaseManager manager]DBWeatherGetAllCitys];
        if(data.count == 0){
            WeatherLocationHelper *helper = [WeatherLocationHelper helper];
            helper.delegate = self;
            helper.isFirstTime = YES;
            [helper startLocation];
            return;
        }
    }
    
    NSInteger index = self.swipView.currentItemIndex;
    
    self.currentWeatherView = (WeatherView *)self.swipView.currentItemView;
    NSString *currentCityName = ((WeatherDataModel *)self.dataSource[index]).basic.city;
   
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpManager *httpManager = [HttpManager manager];
        [httpManager getWeatherDataByCityName:currentCityName dataHandle:^(WeatherDataModel * _Nonnull dataModel) {
            weakSelf.dataSource[index] = dataModel;
            [weakSelf.swipView reloadItemAtIndex:self.swipView.currentItemIndex];
            [weakSelf postData:dataModel];
        }];
    });
}

- (void)postData:(WeatherDataModel *)dataModel{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCityData" object:dataModel];
}

#pragma mark - Getters and Setters

- (SwipeView *)swipView{
    if(!_swipView){
        _swipView = [[SwipeView alloc]initWithFrame:self.view.bounds];
        _swipView.pagingEnabled = YES;
        _swipView.delegate = self;
        _swipView.dataSource = self;
    }
    return _swipView;
}

- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _scrollView.contentSize =CGSizeMake(GlobalScreenWidth, GlobalScreenHeight+1);
    }
    return _scrollView;
}

@end
