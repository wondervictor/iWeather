//
//  SearchViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/15.
//  Copyright © 2016年 VicChan. All rights reserved.
//
//  宏

#define XHEIGHT self.view.frame.size.height
#define XWIDTH  self.view.frame.size.width
#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]

//  Model
#import "WeatherRequest.h"
#import "RealTimeWeather.h"
#import "WeekWeather.h"
#import "LifeWeather.h"

//  View
#import "SearchView.h"

//  Controller
#import "SearchViewController.h"

@interface SearchViewController ()<WeatherRequestDelegate,UISearchBarDelegate,UIScrollViewDelegate>

//  滑动手势
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
//  请求引擎
@property (nonatomic, strong) WeatherRequest *requestEngine;
//  SearchBar
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.swipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];     //   shut gesture
    self.requestEngine = [[WeatherRequest alloc]initRequest];
    self.requestEngine.delegate = self;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64,XWIDTH ,41 )];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入城市";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;

    [self.searchBar setBarTintColor:DEFAULT_COLOR];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"back.png"];
    [self.searchBar setTintColor:[UIColor whiteColor]];
   /**
    UIView *views = [[self.searchBar subviews] objectAtIndex:0];
    for (id object in [views subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *cancel = (UIButton *)object;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    */
    
    [self.view addSubview:self.searchBar];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 120, -XWIDTH, XHEIGHT-200)];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
#warning height
    self.scrollView.contentSize = CGSizeMake(XWIDTH, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((XWIDTH-60)/2.0,XHEIGHT-60,60 , 60)];
    cancelBtn.backgroundColor = [UIColor cyanColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 30.0f;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"search view controller back to master view controller");
    }];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"search view controller back to master view controller");
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.requestEngine startRequestWithCityName:searchBar.text];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/**
 NULL
 nil
 Nil
 NSNull
 区别
 */

#pragma mark - WeatherRequestDelegate 

- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (!error) {
       
        WeatherParse *paser = [WeatherParse sharedManager];
        RealTimeWeather *realTimeWeather = [paser parseRealTimeWeather:data];
        LifeWeather *lifeWeather = [paser parseLifeWeather:data];
        NSArray *listWeather = [paser getWeekWeatherArray:data];
        NSDictionary *pm25 = [paser parseForPM25:data];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:4];
        [dict setObject:realTimeWeather forKey:@"realtime"];
        [dict setObject:lifeWeather forKey:@"life"];
        [dict setObject:listWeather forKey:@"week"];
        [dict setObject:pm25 forKey:@"pm25"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        // UI  搭建
        
        
        
        });
    }
    else if ([error isEqualToString:@"1"])
    {
        NSLog(@"no data");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"无法搜索到城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.searchBar.text = @"";
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([error isEqualToString:@"2"])
    {
       //  网络故障
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
