//
//  RealTimeView.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//


#import "RealTimeView.h"

#define WIDTH  self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation RealTimeView

- (id)initWithFrame:(CGRect)frame withRealTimeWeather:(RealTimeWeather *)realWeather
{
    self = [super initWithFrame:frame];
    CGFloat sideLength = 280;
    if (WIDTH < 375 && [UIScreen mainScreen].bounds.size.height == 480) {
        sideLength = 200;
    }
    else if (WIDTH < 375 && [UIScreen mainScreen].bounds.size.height == 568) {
        sideLength = 220;
    }
    if (self) {
        [self configureComponentsWithSideLength:sideLength];
        [self configureImage:realWeather.img];
        self.cityNameLabel.text = realWeather.cityName;
        self.weatherLabel.text = realWeather.weatherCondition;
        self.tempLabel.text = realWeather.weatherTemp;
        
    }
    return self;
}
#warning constraints

- (void)configureComponentsWithSideLength:(CGFloat)sideLength
{
    self.weatherImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, 20, sideLength, sideLength)];
    self.weatherImg.backgroundColor = [UIColor clearColor];
    
    self.cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, sideLength + 20, sideLength, sideLength/4-30) ];
    self.cityNameLabel.backgroundColor = [UIColor clearColor];
    self.cityNameLabel.textAlignment = NSTextAlignmentCenter;
    self.cityNameLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.font = [UIFont fontWithName:@"Helvetica" size:sideLength/12.0 + 2.0];
    self.cityNameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, 5*sideLength/4 - 10, sideLength, sideLength/4-40)];
    self.weatherLabel.backgroundColor = [UIColor clearColor];
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.font = [UIFont fontWithName:@"Helvetica" size:sideLength/15.0 + 2.0];
    
    self.tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/10.0, 3*sideLength/2 - 40, sideLength/5, sideLength/5)];
    self.tempLabel.textAlignment = NSTextAlignmentCenter;
    self.tempLabel.font = [UIFont fontWithName:@"Helvetica" size:sideLength/6.0];
    self.tempLabel.backgroundColor = [UIColor clearColor];
    self.tempLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.weatherLabel];
    [self addSubview:self.tempLabel];
    [self addSubview:self.cityNameLabel];
    
}

- (void)configureImage:(NSString *)imageNum
{
    NSInteger row = imageNum.integerValue;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImageList" ofType:@"plist"];
    NSArray *listImage = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSDictionary *dict = [listImage objectAtIndex:row];
    self.weatherImg.image = [UIImage imageNamed:[dict valueForKey:@"Img"]];
    [self addSubview:self.weatherImg];

}



@end
