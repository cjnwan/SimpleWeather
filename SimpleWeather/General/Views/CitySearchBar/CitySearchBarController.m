//
//  CitySearchBarController.m
//  SimpleWeather
//
//  Created by 陈剑南 on 1/12/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import "CitySearchBarController.h"


@interface CitySearchBarController()<UISearchBarDelegate>



@end

@implementation CitySearchBarController

#pragma mark - LifeCycle

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithSearchVC:(UIViewController *)VC searchBarFrame:(CGRect)searchBarFrame Font:(UIFont *)font textColor:(UIColor *)textColor tintColor:(UIColor *)tintColor{
    if(self = [super initWithSearchResultsController:VC]){
        self.citySearchBar = [[CitySearchBar alloc]initWithFrame:searchBarFrame font:font textColor:textColor];
        self.citySearchBar.barTintColor = tintColor;
        self.citySearchBar.tintColor = textColor;
        self.citySearchBar.showsBookmarkButton = NO;
        self.citySearchBar.showsCancelButton = YES;
        self.citySearchBar.delegate = self;
        
    }
    return self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didStartSearching)]){
        [self.delegate didStartSearching];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapOnSearchButton)]){
        [self.delegate didTapOnSearchButton];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapOnCancelButton)]){
        [self.delegate didTapOnCancelButton];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChangeSearchText:)]){
        [self.delegate didChangeSearchText:searchText];
    }
}

@end
