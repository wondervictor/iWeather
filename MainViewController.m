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
#import "WeatherRequest.h"
//  View
#import "RealTimeView.h"
#import "RealTimeWeather.h"
#import "TabBar.h"
//  Controller
#import "MainViewController.h"
//  Frameworks
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface MainViewController()<UIScrollViewDelegate,TabBarDelegate,WeatherRequestDelegate,CLLocationManagerDelegate>
{
    
}
// 显示多城市实时天气的scrollView
@property (nonatomic, strong) UIScrollView *weatherScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) NSInteger numberOfCities;
//城市
@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) TabBar *tabBar;
// request
@property (nonatomic, strong) WeatherRequest *requestEngine;



//  CLLocation
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationCityName;


@end

/**
   *  plist 存储城市数据.
   *  Today's Weather Extension;
   *  缓存.
 */




@implementation MainViewController

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.cityListArray = [[NSMutableArray alloc]init];
    self.numberOfCities = [self getNumberOfCities];
    
    
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
    //请求.
    self.requestEngine = [[WeatherRequest alloc]initRequest];
    self.requestEngine.delegate = self;
    [self.requestEngine startRequestWithCityName:@"宜昌"];
    // Core Location
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self locate];
    
    
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
    [self.view addSubview:self.tabBar];
  
    
}

- (void)reloadView {
    
}

- (void)refreshData {
    
}

- (NSInteger)getNumberOfCities {
    NSArray *list = [[NSArray alloc]initWithContentsOfFile:[self cityListDataPath]];
    if (list != nil) {
        [self.cityListArray addObjectsFromArray:list];
    }
    NSInteger num = [self.cityListArray count];
    return num;
}

- (NSString *)cityListDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"citylist.plist"];
}


 
#pragma  mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark  TabBarDelegate

- (void)subButton_0_Action {

     // [self.cityListArray writeToFile:[self cityListDataPath] atomically:YES];
    
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


#pragma mark  - WeatherRequestDelegate

- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (error == nil) {
        NSLog(@"%@",data);
    }
    else if (error!=nil) {
        NSLog(@"%@",error);
    }
    
}

- (void)locate {
    [self.locationManager startUpdatingLocation];
}

#pragma mark  -  CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {

            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            self.locationCityName = placeMark.locality;
            NSLog(@"%@",placeMark.locality);
            NSLog(@"%@",placeMark.subLocality);

            if (!placeMark) {
               //  error;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                
                });
            });
        }
        else if (error) {
            NSLog(@"Location error: %@",error);
        }
        
    }];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Authorized");
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"AuthorizedWhenInUse");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Denied");
    } else if (status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Restricted");
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"NotDetermined");
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.locationManager stopUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
