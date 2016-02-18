//
//  SettingViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//


#define WIDTH   self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height
#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]


#import "SettingViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@""];
    self.navigationBar.tintColor = [UIColor orangeColor];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPress:)];
    [[UINavigationBar appearance]setBarTintColor:DEFAULT_COLOR];
    [item setTitle:@"设置"];
    [item setLeftBarButtonItem:backButton];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [self.navigationBar pushNavigationItem:item animated:YES];
    [self.view addSubview:self.navigationBar];
    
    
    // Do any additional setup after loading the view.
}
- (void)backButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
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
