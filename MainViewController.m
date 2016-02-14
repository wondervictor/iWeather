//
//  MainViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//
//  宏
#define XHEIGHT self.view.frame.size.height
#define XWIDTH  self.view.frame.size.width
#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]

//  Model
#import "OneNetWork.h"
#import "WeatherParse.h"
//  View
#import "RealTimeView.h"
#import "RealTimeWeather.h"
#import "TabBar.h"
//  Controller
#import "MainViewController.h"

@interface MainViewController()<UIScrollViewDelegate,TabBarDelegate>
{
    
}
// 显示多城市实时天气的scrollView
@property (nonatomic, strong) UIScrollView *weatherScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) NSInteger numberOfCities;

@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) TabBar *tabBar;


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
    
    //NSLog(@"%@", [title sizeWithFont:HELVETICANEUEMEDIUM_FONT(12.0f)];);
    
    
    
    CGFloat settingWidth = 150;
    if (XWIDTH <375) {
        settingWidth = 120;
    }
    self.tabBar = [[TabBar alloc]initTabBarWithFrame:CGRectMake(0, XHEIGHT-50, XWIDTH, 50) withTotalRadius:settingWidth centerRadius:25 subRadius:20 centerImage:@"main" subImages:^(TabBar *tb)
    {
        [tb subButtonImage:@"search" withTag:0];
        [tb subButtonImage:@"add" withTag:1];
        [tb subButtonImage:@"setting" withTag:2];
        [tb subButtonImage:@"about" withTag:3];
    } locationX:0 locationY:0];
    self.tabBar.delegate = self;
    // self.tabBar.layer.borderColor = [UIColor blackColor].CGColor;
    // self.tabBar.layer.borderWidth = 0.3f;
    [self.view addSubview:self.tabBar];
  
    
    //  netWork
    
    NSDictionary *requestParams = @{@"cityname":@"宜昌",
                                    @"dtype":@"json",
                                    @"key":@"5e9055bef55f2e0ac8e3fdb4c0315629"};
    WeatherParse *paser = [WeatherParse sharedManager];
    __block RealTimeWeather *weather = [[RealTimeWeather alloc]init];
    
    NSString *urlString = @"http://op.juhe.cn/onebox/weather/query?";
    
    OneNetWork *oneNetWork = [OneNetWork sharedManager];
    [oneNetWork asynchronousRequestWithURLString:urlString WithRequestMethod:@"POST" params:requestParams withCompletion:^(NSData *data, NSURLResponse *response) {
      //  NSLog(@"%@",data);
        NSDictionary *dict = [paser getWeatherData:data];
        NSLog(@"%@",dict);
        weather = [paser parseRealTimeWeather:dict];
        NSLog(@"%@",weather.cityName);
        
        
    } withError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"%@",weather.cityName);
   
}




#pragma  mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark  TabBarDelegate

- (void)subButton_0_Action {
    
}

- (void)subButton_1_Action {
    
}

- (void)subButton_2_Action {
    
}

- (void)subButton_3_Action {
    
}

- (void)centerButtonClick {
    
}

//  Tab Bar Button Press Event
- (void)firstTouchAtIndex:(NSInteger)index button:(BarButton *)sender {
    if (index == 0) {
        NSLog(@"1 first");
    }
    else if (index == 1) {
        NSLog(@"2 first");
    }
    else if (index == 2) {
        NSLog(@"3 first");
    }
    else if (index == 3) {
        NSLog(@"4 first");
    }
    
}

- (void)secondTouchAtIndex:(NSInteger)index button:(BarButton *)sender {
    if (index == 0) {
        NSLog(@"1 second");
    }
    else if (index == 1) {
        NSLog(@"2 second");
    }
    else if (index == 2) {
        NSLog(@"3 second");
    }
    else if (index == 3) {
        NSLog(@"4 second");
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
