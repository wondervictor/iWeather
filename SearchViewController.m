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

#import "WeatherRequest.h"

#import "SearchViewController.h"

@interface SearchViewController ()<WeatherRequestDelegate>

//  滑动手势
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
//  请求引擎
@property (nonatomic, strong) WeatherRequest *requestEngine;


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

#pragma mark - WeatherRequestDelegate 

- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error {
    
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
