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
#import "weekViewCell.h"
#import "PMView.h"
#import "LifeView.h"
#import "OneHUD.h"
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

// 放置ScrollView中所有城市的天气信息
@property (nonatomic, strong) NSMutableArray *allCityWeather;
// 存放当前天气
@property (nonatomic, strong) NSDictionary *currentWeatherData;
// 存放当前一周天气
@property (nonatomic, strong) NSArray *currentWeekWeatherList;
// 当前天气序号.
@property (nonatomic, assign) NSInteger currentSequence;


//  CLLocation
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *locationCityName;

// Controllers

@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) AddViewController *addViewController;
@property (nonatomic, strong) AboutViewController *aboutViewController;
@property (nonatomic, strong) SettingViewController *settingViewController;

//  推送内容
@property (nonatomic, strong) NSString *notificationString;

@end

static NSInteger counter = 0;

@implementation MainViewController
// 惰性加载
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = DEFAULT_COLOR;
    self.allCityWeather = [[NSMutableArray alloc]init];
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
   
    // 开始请求已有的城市
    OneHUD *hud = [[OneHUD alloc]initWithFrame:CGRectMake(0, 0, 150, 150) withPointDiameter:16 interval:0.25];
    hud.center = self.view.center;
    hud.tag = 211;
    [self.view addSubview:hud];
    for (NSString *name in self.cityListArray) {
        [self.requestEngine startRequestWithCityName:name];
    }
    
    //  网络活动指示器

    
    // Core Location
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // iOS8.0之后需要获取权限
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    // 自定义TabBar
    CGFloat settingWidth = 150;
    if (XWIDTH <375) {
        settingWidth = 120;
    }
    self.tabBar = [[TabBar alloc]initTabBarWithFrame:CGRectMake(0, XHEIGHT-50, XWIDTH, 50)
                                     withTotalRadius:settingWidth
                                        centerRadius:25
                                           subRadius:20
                                         centerImage:@"main"
                                           subImages:^(TabBar *tb)
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
    // 定位按钮
    UIButton *locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 22, 30, 30)];
    [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    locationBtn.layer.cornerRadius = 15.0f;
    locationBtn.layer.masksToBounds = YES;
    [locationBtn addTarget:self action:@selector(locationButtonPress:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:locationBtn];
    // 注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedDataFromSearch:) name:@"GetNewCityNotification_2" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedDataFromAdd:) name:@"DidDeleteCityNotification" object:nil];
    
    self.searchViewController = [[SearchViewController alloc]init];
    self.addViewController = [[AddViewController alloc]init];
    self.aboutViewController = [[AboutViewController alloc]init];
    self.settingViewController = [[SettingViewController alloc]init];
    
    //  推送本地通知
     UILocalNotification *weatherNotification = [[UILocalNotification alloc]init];
    if (weatherNotification != nil) {
        weatherNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:0];
        weatherNotification.repeatInterval = kCFCalendarUnitDay;
        weatherNotification.alertBody = self.notificationString;
        weatherNotification.timeZone = [NSTimeZone defaultTimeZone];
        weatherNotification.alertTitle = @"今日天气";
        weatherNotification.soundName =UILocalNotificationDefaultSoundName;
        weatherNotification.applicationIconBadgeNumber = 1;
        weatherNotification.category = @"CATEGORY";
    }
    [[UIApplication sharedApplication]scheduleLocalNotification:weatherNotification];
    
}
// 本想加进去网络请求，但为实现
- (NSString *)notificationString {
    if (_notificationString == nil) {
        _notificationString = @"iWeather邀请你查看今日天气";
    }
    return _notificationString;
}


- (void)locationButtonPress:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
    // 定位Button
}

- (void)loadCenterWeatherView:(NSDictionary *)weatherData {
    // 58 页崩溃数据报告
    // UI搭建必须在main_queue里，注意之前是否有dispatch_get_global——queue
    dispatch_async(dispatch_get_main_queue(), ^{
        counter ++ ;
        [self.allCityWeather addObject:weatherData];   // 获取所有城市的天气信息
        RealTimeWeather *realTime = [[RealTimeWeather alloc]init];
        WeatherParse *parser = [WeatherParse sharedManager];
        realTime = [parser parseRealTimeWeather:weatherData];
        NSDictionary *dictForCondition = [parser parseForConditionView:weatherData];
        RealTimeView *realTimeView = [[RealTimeView alloc]initWithFrame:CGRectMake(XWIDTH*(counter-1), 0, XWIDTH,XHEIGHT-114 ) withRealTimeWeather:realTime withConditionData:dictForCondition];
        realTimeView.tag = 500+counter;
        [self.weatherScrollView addSubview:realTimeView];
        if ([self.cityListArray count] == counter) {
            [self writeDataToFile];    // 很笨的一种方式－－使用plist文件写入缓存
                                    // 本想用NSURLSession来设置缓存，但程序一次会有多个不同的请求，会共用一个缓存。
        }
        else {
        }
    });
   
}

- (NSInteger)numberOfCities {
    return [self.cityListArray count];
}

- (NSInteger)getNumberOfCities {
    NSArray *list = [[NSArray alloc]initWithContentsOfFile:[self cityListDataPath]];
    if (list != nil) {
        [self.cityListArray addObjectsFromArray:list];
    }
    else if (list == nil) {
        [self.cityListArray addObjectsFromArray:@[@"北京",@"上海"]]; // 如果用户删除所有城市或者第一次加载会默认选择北京上海
        [self.cityListArray writeToFile:[self cityListDataPath] atomically:YES
         ];
    }
    NSInteger num = [self.cityListArray count];
    return num;
}
// 城市列表文件存储－Plist
- (NSString *)cityListDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"citylist.plist"];
}
// 缓存文件存储-Plist
- (NSString *)cityWeatherDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"cache.plist"];
}
// 讲缓存文件转化为NSData才能写入Plist文件
- (void)writeDataToFile {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.allCityWeather];
    [data writeToFile:[self cityWeatherDataPath] atomically:YES];
    
}

// Lazy Load
- (NSInteger)currentSequence {
    return self.weatherScrollView.contentOffset.x/XWIDTH;
}

 
#pragma  mark  UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentSequence = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
}

#pragma mark  TabBarDelegate

- (void)subButton_0_Action {

    [self presentViewController:self.searchViewController animated:YES completion:nil];
    
}

- (void)subButton_1_Action {
    self.addViewController.list = self.cityListArray;
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
    WeatherParse *parser = [WeatherParse sharedManager];
    self.currentWeekWeatherList = [parser getWeekWeatherArray:[self.allCityWeather objectAtIndex:self.currentSequence ] ];
    ARSPopover *popoverController = [ARSPopover new];
    popoverController.sourceView = sender;
    popoverController.sourceRect =CGRectMake(CGRectGetMidX(sender.bounds), CGRectGetMaxY(sender.bounds)-40, 0, 0);
    popoverController.contentSize = CGSizeMake(XWIDTH, 360);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 350) style:UITableViewStylePlain ];
            tableView.center = CGPointMake(XWIDTH/2, 175);
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
            NSDictionary *pm25Dictionary = [parser parseForPM25:[self.allCityWeather objectAtIndex:self.currentSequence]];
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
    popoverController.contentSize = CGSizeMake(XWIDTH, 300);
    popoverController.arrowDirection = UIPopoverArrowDirectionDown;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            WeatherParse *parser = [WeatherParse sharedManager];
            LifeWeather *life = [parser parseLifeWeather:[self.allCityWeather objectAtIndex:self.currentSequence]];
            LifeView *view = [[LifeView alloc]initWithFrame:CGRectMake(10, 10, XWIDTH-30, 300) withData:life];
            [popover.view addSubview:view];
            
        }];
    }];
}


#pragma mark  - WeatherRequestDelegate
// 天气请求的代理方法
- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (error == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            OneHUD *hud = [self.view viewWithTag:211];
            [hud removeFromSuperview];
        });
        self.currentWeatherData = data;
        [self loadCenterWeatherView:data];
    }
    else if (error!=nil) {
        [self requestError:error];
    }
    
}
//  请求错误.
- (void)requestError:(NSString *)error {
    if ([error isEqualToString:@"3"]) {
        NSLog(@"网络连接故障");
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"网络连接故障" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSData *data = [[NSData alloc]initWithContentsOfFile:[self cityWeatherDataPath] ];
                NSArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                for (NSDictionary *dict in tempArray) {
                    [self loadCenterWeatherView:dict];
                }
            }];
            UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self subButtonPress:nil];
            }];
            [alert addAction:cancelAction];
            [alert addAction:refreshAction];
        
            [self presentViewController:alert animated:YES completion:^{
                OneHUD *hud = [self.view viewWithTag:211];
                [hud removeFromSuperview];
            }];
        });
        
        
    }
    else if ([error isEqualToString:@"2"]) {
        NSLog(@"无法获取城市信息");
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
            __block NSString *city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            
            if (!placeMark) {
               //  error;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.locationCityName = city;
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    for (NSString *name in self.cityListArray) {
                        if ([name isEqualToString:city]) {
                            //  如果已经添加该城市
                            NSString *message = @"您已经添加该城市";
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位信息" message:message preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:cancelAction];
                            [self presentViewController:alert animated:YES completion:^{
                                [self.locationManager stopUpdatingLocation];
                                
                            }];
                            return ;

                        }
                    }
                    NSString *message = [NSString stringWithFormat:@"使用此城市：%@",city ];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位信息" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.cityListArray addObject:self.locationCityName];
                        
                        self.weatherScrollView.contentSize = CGSizeMake(XWIDTH*[self.cityListArray count], XHEIGHT -114);
                        [self subButtonPress:nil];
                    }];
                    
                    [alert addAction:confirmAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:^{
                        [self.locationManager stopUpdatingLocation];

                    }];
                    
                    
                });
            });
        }
        else if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"无法获取定位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:^{
                [self.locationManager stopUpdatingLocation];

            }];
        }
        
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位信息" message:@"无法获取定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        [self.locationManager stopUpdatingLocation];

    }];
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
// 由于MainViewController有两个表示图－－采用View Tag来标示
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 111) {
        return 50;
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
    cell.date.text = weather.date;
    cell.date.textColor = [UIColor grayColor];
    cell.image.image = [self configureImage:[day objectAtIndex:0]];
    cell.temp.text = [NSString stringWithFormat:@"%@°",[day objectAtIndex:2]];
    cell.temp.textColor = [UIColor orangeColor];
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
// Location - TableView 的选中事件--未完成
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 222) {
    }
}

// Refresh
#pragma  mark - subButtonDelegate 
- (void)subButtonPress:(subButton *)button {
    counter = 0;
    [self.allCityWeather removeAllObjects];     // 清空
    for (NSInteger i=1;i<=[self.cityListArray count];i++) {
        RealTimeView *view = [self.view viewWithTag:(500+i)];
        [view removeFromSuperview];
        [self.requestEngine startRequestWithCityName:[self.cityListArray objectAtIndex:i-1]];
    }
}

//  handle Notifications

- (void)receivedDataFromSearch:(NSNotification *)notification {
    NSString *newName = (NSString *)notification.object;
    for (NSString * name  in self.cityListArray) {
        if ([newName isEqualToString:name]) {
            return;
        }
    }
    [self.cityListArray addObject:newName];
    self.weatherScrollView.contentSize = CGSizeMake(XWIDTH*[self.cityListArray count], XHEIGHT -114);
    [self.cityListArray writeToFile:[self cityListDataPath] atomically:YES];
    [self subButtonPress:nil];
}

- (void)receivedDataFromAdd:(NSNotification *)notification {
    NSString *name = (NSString *)notification.object;
    [self.cityListArray removeObject:name];
    self.weatherScrollView.contentSize = CGSizeMake(XWIDTH*[self.cityListArray count], XHEIGHT -114);
    [self.cityListArray writeToFile:[self cityListDataPath] atomically:YES];
    [self subButtonPress:nil];
}

#pragma mark - ARSPopoverDelegate

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
