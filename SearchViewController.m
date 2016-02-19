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

@property (nonatomic, strong) UINavigationBar *navigationBar;

@property (nonatomic, strong) NSString *searchName;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.requestEngine = [[WeatherRequest alloc]initRequest];
    self.requestEngine.delegate = self;
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,XWIDTH , 64)];
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@""];
    [item setTitle:@"搜索"];
    [[UINavigationBar appearance]setBarTintColor:DEFAULT_COLOR];

    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [self.navigationBar pushNavigationItem:item animated:YES];
    [self.view addSubview:self.navigationBar];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,XWIDTH-40 ,41)];
    self.searchBar.center = CGPointMake(XWIDTH/2, 200);
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入城市";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;

    [self.searchBar setBarTintColor:DEFAULT_COLOR];
    //self.searchBar.showsCancelButton = YES;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"back.png"];
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
    //  点击背景关闭键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackGround:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,200 , 50)];
    cancelBtn.center = CGPointMake(XWIDTH/2, XHEIGHT-25);
    cancelBtn.backgroundColor = [UIColor orangeColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 25.0f;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    // 热门城市
    // 北京
    UIButton *button_1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    button_1.center = CGPointMake(XWIDTH/2, 300);
    [button_1 setTitle:@"北京" forState:UIControlStateNormal];
    [button_1 addTarget:self action:@selector(searchHotCity:) forControlEvents:UIControlEventTouchDown];
    button_1.backgroundColor = [UIColor clearColor];
    [button_1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //.titleLabel.textColor = [UIColor orangeColor];
    // 上海
    UIButton *button_2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    button_2.center = CGPointMake(XWIDTH/2, 350);
    [button_2 setTitle:@"上海" forState:UIControlStateNormal];
    [button_2 addTarget:self action:@selector(searchHotCity:) forControlEvents:UIControlEventTouchDown];
    button_2.backgroundColor = [UIColor clearColor];
    [button_2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.view addSubview:button_1];
    [self.view addSubview:button_2];
    
    // Do any additional setup after loading the view.
}

- (void)searchHotCity:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"北京"]) {
        [self.requestEngine startRequestWithCityName:@"北京"];
    }
    else if ([sender.titleLabel.text isEqualToString:@"上海"])
    {
        [self.requestEngine startRequestWithCityName:@"上海"];

    }
    
}

- (void)cancelButtonClick:(UIButton *)sender {
  
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"search view controller back to master view controller");
    }];
 
}

- (void)tapBackGround:(UITapGestureRecognizer *)recognizer {
    [self.searchBar resignFirstResponder];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [[self.scrollView.subviews lastObject]removeFromSuperview];
    [self.scrollView removeFromSuperview];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchName = searchBar.text;
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
       
        [self loadResultView:data];
    }
    else if ([error isEqualToString:@"1"])
    {
        NSLog(@"no data");
        dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"无法搜索到城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.searchBar.text = @"";
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        });
    }
    else if ([error isEqualToString:@"2"])
    {
       //  网络故障
    }
}


- (void)loadResultView:(NSDictionary *)data {
    // UI  搭建
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(-60, 30, 50, 30)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchDown];
        backButton.tag = 211;
        backButton.backgroundColor = [UIColor clearColor];
        
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(XWIDTH+60, 30, 30, 30) ];
        [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonPress:) forControlEvents:UIControlEventTouchDown];
        addButton.tag = 212;
        addButton.layer.cornerRadius = 15.0f;
        addButton.layer.masksToBounds = YES;
        
        [self.view addSubview:backButton];
        [self.view addSubview:addButton];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,0,0)];
        self.scrollView.tag = 101;
        self.scrollView.backgroundColor = DEFAULT_COLOR;
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(XWIDTH, 700);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.swipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
        self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.scrollView addGestureRecognizer:self.swipeGestureRecognizer];     //   shut gesture

        [self.view addSubview:self.scrollView];
        
        WeatherParse *paser = [WeatherParse sharedManager];
        RealTimeWeather *realTimeWeather = [paser parseRealTimeWeather:data];
       // NSLog(@"%@",realTimeWeather.cityName);
        self.searchName = realTimeWeather.cityName;
        LifeWeather *lifeWeather = [paser parseLifeWeather:data];
        NSArray *listWeather = [paser getWeekWeatherArray:data];
        NSDictionary *pm25 = [paser parseForPM25:data];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:4];
        [dict setObject:realTimeWeather forKey:@"realtime"];
        [dict setObject:lifeWeather forKey:@"life"];
        [dict setObject:listWeather forKey:@"week"];
        [dict setObject:pm25 forKey:@"pm25"];
        SearchView *view = [[SearchView alloc]initWithFrame:CGRectMake(0, 0,XWIDTH , 700) withData:dict];
        [self.scrollView addSubview:view];
        [UIView animateWithDuration:0.4f animations:^{
            self.scrollView.frame = CGRectMake(0, 0, XWIDTH, XHEIGHT-64);
            self.scrollView.center = CGPointMake(XWIDTH/2, (XHEIGHT+64)/2);
            backButton.frame = CGRectMake(10, 30, 50, 30);
            addButton.frame = CGRectMake(XWIDTH-50, 30, 30, 30);
            
        } completion:^(BOOL finished) {
            [self.view addSubview:backButton];
            

        }];
        
        
    });
    

}

- (void)backButtonPress:(UIButton *)sender {
    [sender removeFromSuperview];
    [UIView animateWithDuration:0.4f animations:^{
        CGRect rect = CGRectMake(0, 0, 0, 0);
        self.scrollView.frame = rect;
        self.scrollView.center = CGPointMake(XWIDTH/2, (XHEIGHT+64)/2);
        UIButton *button_1 = [self.view viewWithTag:211];
        UIButton *button_2 = [self.view viewWithTag:212];
        button_1.frame = CGRectMake(-60, 30, 50, 30);
        button_2.frame = CGRectMake(XWIDTH+60, 30, 30, 30);
    } completion:^(BOOL finished) {
        [[[self.scrollView subviews] lastObject]removeFromSuperview];
        [self.scrollView removeFromSuperview];
        UIButton *button_1 = [self.view viewWithTag:211];
        UIButton *button_2 = [self.view viewWithTag:212];
        [button_1 removeFromSuperview];
        [button_2 removeFromSuperview];
    }];
    
    
}

#pragma mark - SearchViewDelegate



- (void)addButtonPress:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetNewCityNotification_1" object:self.searchName userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GetNewCityNotification_2" object:self.searchName userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:^{}];

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     UIScrollView *view = [self.view viewWithTag:101];
    [[view.subviews lastObject]removeFromSuperview];
    [view removeFromSuperview];
    UIButton *button_1 = [self.view viewWithTag:211];
    UIButton *button_2 = [self.view viewWithTag:212];
    [button_1 removeFromSuperview];
    [button_2 removeFromSuperview];

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
