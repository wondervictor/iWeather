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
#import "ConditionView.h"
#import "weekViewCell.h"
#import "PMView.h"

//  Controller
#import "MainViewController.h"
#import "SearchViewController.h"
#import "AddViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "ARSPopover.h"
//  Frameworks
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface MainViewController()<UIScrollViewDelegate,TabBarDelegate,WeatherRequestDelegate,CLLocationManagerDelegate,subButtonDelegate,ARSPopoverDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
// 显示多城市实时天气的scrollView
@property (nonatomic, strong) UIScrollView *weatherScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) NSInteger numberOfCities;
// 城市列表
@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) TabBar *tabBar;
// request
@property (nonatomic, strong) WeatherRequest *requestEngine;
// 存放所有城市天气的可变数组
@property (nonatomic, strong) NSMutableArray *cityWeatherDataList;
// 可变数组存放realTimeView s
@property (nonatomic, strong) NSMutableArray *realTimeViews;
// 存放当前天气
@property (nonatomic, strong) NSDictionary *currentWeatherData;
// 存放当前一周天气
@property (nonatomic, strong) NSArray *currentWeekWeatherList;
//  CLLocation
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationCityName;

// Controllers

@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) AddViewController *addViewController;
@property (nonatomic, strong) AboutViewController *aboutViewController;
@property (nonatomic, strong) SettingViewController *settingViewController;

@end

/**
   *  plist 存储城市数据.
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
    
    CGRect scrollViewRect = CGRectMake(0, 64, XWIDTH, XHEIGHT - 114);
    self.weatherScrollView = [[UIScrollView alloc]initWithFrame:scrollViewRect];
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.backgroundColor = [UIColor clearColor];
    self.weatherScrollView.pagingEnabled = YES;
    self.weatherScrollView.contentSize = CGSizeMake(XWIDTH * (_numberOfCities==0 ? 1:_numberOfCities), XHEIGHT -114);
    self.weatherScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.weatherScrollView];
    
    //请求.

    self.requestEngine = [[WeatherRequest alloc]initRequest];
    self.requestEngine.delegate = self;
    [self.requestEngine startRequestWithCityName:@"宜都"];
    
    
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
    
    // title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44) ];
    titleLabel.center = CGPointMake(XWIDTH/2, 42);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"iWeather";
    [self.view addSubview:titleLabel];
    
    // refreshButton
    subButton *refreshBtn = [[subButton alloc]initWithFrame:CGRectMake(XWIDTH - 50,22,30 , 30)];
    refreshBtn.delegate = self;
    refreshBtn.layer.cornerRadius = 15.0f;
    refreshBtn.layer.masksToBounds = YES;
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.view addSubview:refreshBtn];
    
    self.searchViewController = [[SearchViewController alloc]init];
    self.addViewController = [[AddViewController alloc]init];
    self.aboutViewController = [[AboutViewController alloc]init];
    self.settingViewController = [[SettingViewController alloc]init];
}
                              
- (void)reloadView {
    
}

- (void)refreshData {
    
}


- (void)loadCenterWeatherView:(NSDictionary *)weatherData {
   //   58 页崩溃数据报告
    //NSLog(@"%@",self.currentWeatherData);
    dispatch_async(dispatch_get_main_queue(), ^{
        
    RealTimeWeather *realTime = [[RealTimeWeather alloc]init];
    WeatherParse *parser = [WeatherParse sharedManager];
    realTime = [parser parseRealTimeWeather:weatherData];
    NSDictionary *dictForCondition = [parser parseForConditionView:weatherData];
    self.currentWeekWeatherList = [parser getWeekWeatherArray:weatherData];
    RealTimeView *realTimeView = [[RealTimeView alloc]initWithFrame:CGRectMake(0, 0, XWIDTH, 3*(XHEIGHT-114)/4) withRealTimeWeather:realTime];
    [self.weatherScrollView addSubview:realTimeView];
        
    ConditionView *conditionView = [[ConditionView alloc]initWithFrame:CGRectMake(0, 3*(XHEIGHT-114)/4, XWIDTH, (XHEIGHT - 114)/4) withData:dictForCondition];
    [self.weatherScrollView addSubview:conditionView];
    
    });
}

- (NSInteger)getNumberOfCities {
    NSArray *list = [[NSArray alloc]initWithContentsOfFile:[self cityListDataPath]];
    if (list != nil) {
        [self.cityListArray addObjectsFromArray:list];
    }
    list = @[@"北京",@"上海",@"武汉"];
    [self.cityListArray addObjectsFromArray:list];
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
   //  self.searchViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:self.searchViewController animated:YES completion:^{
        NSLog(@"search view controller");
    }];
    
    
}

- (void)subButton_1_Action {
    [self presentViewController:self.addViewController animated:YES completion:^{
        NSLog(@"add view controller");
    }];
    
}

- (void)subButton_2_Action {
[self presentViewController:self.settingViewController animated:YES completion:^{
    NSLog(@"setting View Controller");
}];
}

- (void)subButton_3_Action {
    [self presentViewController:self.aboutViewController animated:YES completion:nil];
}

- (void)centerButtonClick {
}
//  TabBar Button_1_WeekTemp
- (void)barButton_0_Touched:(BarButton *)sender {
    ARSPopover *popoverController = [ARSPopover new];
        popoverController.sourceView = sender;
    popoverController.sourceRect =CGRectMake(CGRectGetMidX(sender.bounds), CGRectGetMaxY(sender.bounds)-40, 0, 0);
    popoverController.contentSize = CGSizeMake(XWIDTH, 230);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, 320, 210) style:UITableViewStylePlain ];
            tableView.center = CGPointMake(XWIDTH/2, 115);
            tableView.tag = 111;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = [UIColor clearColor];
            [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([weekViewCell class]) bundle:nil] forCellReuseIdentifier:@"weekCell"];
            [popover.view addSubview:tableView];

            
        }];
    }];

}
//  TabBar Button_2_PM2.5
- (void)barButton_1_Touched:(BarButton *)sender {
    ARSPopover *popoverController = [ARSPopover new];
    popoverController.sourceView = sender;
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds), CGRectGetMaxY(sender.bounds)-40, 0, 0);
    popoverController.contentSize = CGSizeMake(XWIDTH, 180);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            WeatherParse *parser = [WeatherParse sharedManager];
            NSDictionary *pm25Dictionary = [parser parseForPM25:self.currentWeatherData];
            PMView *view = [[PMView alloc]initWithFrame:CGRectMake(10, 0, XWIDTH-30,180 ) withData:pm25Dictionary];
            [popover.view addSubview:view];
            
        }];
    }];

}
//  TabBar Button_3_Location
- (void)barButton_2_Touched:(BarButton *)sender {
    ARSPopover *popoverController = [ARSPopover new];
    popoverController.sourceView = sender;
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds), CGRectGetMaxY(sender.bounds)-40, 0, 0);
    popoverController.contentSize = CGSizeMake(XWIDTH, 40*self.numberOfCities + 20);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, 320, 40*self.numberOfCities) style:UITableViewStylePlain];
            tableView.tag = 222;
            tableView.center = CGPointMake(XWIDTH/2, 10 + 20*self.numberOfCities);
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = [UIColor clearColor];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
            [popover.view addSubview:tableView];
            
            
        }];
    }];
}
//  TabBar Button_4_Info (life)
- (void)barButton_3_Touched:(BarButton *)sender {
    
    
    ARSPopover *popoverController = [ARSPopover new];
    popoverController.sourceView = sender;
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds), CGRectGetMaxY(sender.bounds)-40, 0, 0);
    popoverController.contentSize = CGSizeMake(XWIDTH, 200);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            WeatherParse *parser = [WeatherParse sharedManager];
            LifeWeather *life = [parser parseLifeWeather:self.currentWeatherData];
            
            
            
            
        }];
    }];
}


#pragma mark  - WeatherRequestDelegate

- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (error == nil) {
        self.currentWeatherData = data;
        [self loadCenterWeatherView:data];
    }
    else if (error!=nil) {
        [self requestError:error];
    }
    
}
//  请求错误.
- (void)requestError:(NSString *)error {
    
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
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 111) {
        return 30;

    }
    else if (tableView.tag == 222) {
        return 40;
    }
    else {
        return 0;
    }
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 111) {
        return 7;
    }
    else if (tableView.tag == 222) {
        return self.numberOfCities;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 111) {

    weekViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weekCell" forIndexPath:indexPath];
    WeekWeather *weather = [self.currentWeekWeatherList objectAtIndex:indexPath.row];
    NSArray *day = weather.dayWeather;
    cell.backgroundColor = [UIColor clearColor];
    cell.date.text = weather.date;   //  在iPhone4s上模拟有点问题。
    //cell.image
    cell.image.image = [self configureImage:[day objectAtIndex:0]];
    CGRect frame = cell.image.frame;
    frame.size.height = 30.0;
    frame.size.width = 30.0;
    cell.image.frame = frame;
    cell.temp.text = [NSString stringWithFormat:@"%@°",[day objectAtIndex:2]];
    cell.weather.font = [UIFont systemFontOfSize:15];
    cell.temp.font = [UIFont systemFontOfSize:15];
    cell.weather.text = [day objectAtIndex:1];
    return cell;
    }
    else if (tableView.tag == 222) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [self.cityListArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    return nil;
}
//   配置天气图片
- (UIImage *)configureImage:(NSString *)imageNum
{
    NSInteger row = imageNum.integerValue;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImageList" ofType:@"plist"];
    NSArray *listImage = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSDictionary *dict = [listImage objectAtIndex:row];
    UIImage *image = [UIImage imageNamed:[dict valueForKey:@"img"]];
    return image;
}

#pragma mark - UITableViewDelegate
// Location - TableView 的选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 222) {
        NSLog(@"%@",[self.cityListArray objectAtIndex:indexPath.row]);
    }
}

// Refresh
#pragma  mark - subButtonDelegate 
- (void)subButtonPress:(subButton *)button {
    //[self.requestEngine startRequestWithCityName:@"宜都"];
}

#pragma mark <ARSPopoverDelegate>

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    // delegate for you to use.
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
    return YES;
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
