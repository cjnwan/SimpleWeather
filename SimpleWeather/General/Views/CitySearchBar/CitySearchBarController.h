//
//  CitySearchBarController.h
//  SimpleWeather
//
//  Created by 陈剑南 on 1/12/16.
//  Copyright © 2016 Jimmy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySearchBar.h"

@protocol CitySearchBarControllerDelegate <NSObject>

- (void)didStartSearching;
- (void)didTapOnSearchButton;
- (void)didTapOnCancelButton;
- (void)didChangeSearchText:(NSString *)searchText;


@end

@interface CitySearchBarController : UISearchController

@property(nonatomic, strong)CitySearchBar *citySearchBar;

@property(nonatomic, weak)id<CitySearchBarControllerDelegate>delegate;

- (instancetype)initWithSearchVC:(UIViewController *)VC searchBarFrame:(CGRect)searchBarFrame Font:(UIFont *)font textColor:(UIColor *)textColor tintColor:(UIColor *)tintColor;

@end
