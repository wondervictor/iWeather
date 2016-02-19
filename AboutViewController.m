//
//  AboutViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#define XHEIGHT self.view.frame.size.height
#define XWIDTH  self.view.frame.size.width

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"About.jpg"];
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.center = CGPointMake(XWIDTH/2, 30);
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    titleLabel.text = @"关于iWeather";
    [self.view addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,200 , 50)];
    cancelBtn.center = CGPointMake(XWIDTH/2, XHEIGHT-25);
    cancelBtn.backgroundColor = [UIColor cyanColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 25.0f;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    UIButton *rankBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0 ,200 , 40)];
    rankBtn.center = CGPointMake(XWIDTH/2, 340);
    rankBtn.backgroundColor = [UIColor orangeColor];
    rankBtn.layer.cornerRadius = 5.0f;
    [rankBtn setTitle:@"给我们评分" forState:UIControlStateNormal];
    [rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rankBtn addTarget:self action:@selector(rankButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    rankBtn.layer.zPosition = 1;
    [self.view addSubview:rankBtn];
    
    self.versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.versionLabel.center = CGPointMake(XWIDTH/2, 290);
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.backgroundColor = [UIColor clearColor];
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.text = @"V1.0";
    [imageView addSubview:self.versionLabel];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    shareBtn.center = CGPointMake(XWIDTH/2, 410);
    shareBtn.backgroundColor = [UIColor orangeColor];
    shareBtn.layer.cornerRadius = 5.0f;
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setTitle:@"推荐给好友" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    
    
    //rankBtn.enabled = YES;
    
    
    // Do any additional setup after loading the view.
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rankButtonPress:(UIButton *)sender {
    //  AppStore 评分
}

- (void)shareButtonPress:(UIButton *)sender {
    //  推荐给好友
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
