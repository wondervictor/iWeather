//
//  MainViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#define XHEIGHT self.view.frame.size.height
#define XWIDTH  self.view.frame.size.width
#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]

#import "RealTimeView.h"
#import "RealTimeWeather.h"



#import "MainViewController.h"
@interface MainViewController()<UIScrollViewDelegate>
{
    
}
// 显示多城市实时天气的scrollView
@property (nonatomic, strong) UIScrollView *weatherScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) NSInteger numberOfCities;

@property (nonatomic, strong) NSMutableArray *cityListArray;




@end

@implementation MainViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    /*
    CGRect scrollViewRect = CGRectMake(0, 64, XWIDTH, XHEIGHT-124);
    self.weatherScrollView = [[UIScrollView alloc]initWithFrame:scrollViewRect];
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.contentSize = CGSizeMake(self.numberOfCities * XWIDTH, XHEIGHT-124);
    self.weatherScrollView.backgroundColor = [UIColor clearColor];
    self.weatherScrollView.pagingEnabled = YES;
    self.weatherScrollView.showsHorizontalScrollIndicator = NO;
    self.weatherScrollView.showsVerticalScrollIndicator = NO;
    self.weatherScrollView.bounces = YES;
    [self.view addSubview:self.weatherScrollView];
    */
    /*
    RealTimeWeather *weather = [[RealTimeWeather alloc]init];
    weather.weatherTemp = @"23";
    weather.weatherCondition = @"晴";
    weather.img = @"3";
    weather.cityName = @"北京";
    
    RealTimeView *view = [[RealTimeView alloc]initWithFrame:CGRectMake(0, 64, XWIDTH, 500) withRealTimeWeather:weather];
    [self.view addSubview:view];
     */
    
    
   
}




#pragma  mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
