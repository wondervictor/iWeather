//
//  RealTimeView.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//
// iPhone4/4s         : H:274.5   W:320
// iPhone5/5s/5c      : H:340.5   W:320
// iPhone6/6s         : H:414.75   W:375
// iPhone6+/iPhone6s+ : H:466.5   W:414
//


#import "RealTimeView.h"

#define WIDTH  self.frame.size.width
#define HEIGHT self.frame.size.height

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface RealTimeView()
@property (nonatomic, assign) CGFloat proportion;
@end

@implementation RealTimeView

- (id)initWithFrame:(CGRect)frame withRealTimeWeather:(RealTimeWeather *)realWeather
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (DEVICE_HEIGHT == 480.0) {
            _proportion = 1.0;
        }
        else if (DEVICE_HEIGHT == 568.0) {
            _proportion = 340.5/274.5;
        }
        else if (DEVICE_HEIGHT == 667.0) {
            _proportion = 414.75/274.5;
        }
        else if (DEVICE_HEIGHT == 736.0) {
            _proportion = 466.5/274.5;
        }
        CGFloat sideLength = 170;    // 中心图片宽度
        CGFloat tempHeight = 50;     // 温度标签高度
        sideLength = sideLength * _proportion;
        tempHeight = tempHeight * _proportion;
        
        [self configureComponentsWithSideLength:sideLength withTempHeight:tempHeight];
        [self configureImage:realWeather.img];
        self.cityNameLabel.text = realWeather.cityName;
        self.weatherLabel.text = realWeather.weatherCondition;
        self.tempLabel.text = realWeather.weatherTemp;
        
    }
    return self;
}


- (void)configureComponentsWithSideLength:(CGFloat)sideLength withTempHeight:(CGFloat)tempHeight
{
    self.weatherImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, 0, sideLength, sideLength)];
    self.weatherImg.backgroundColor = [UIColor clearColor];
    
    CGFloat cityHeight = (HEIGHT - (sideLength + tempHeight))/2;    // 城市标签高度
    
    self.cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, sideLength -10 , sideLength, cityHeight) ];
    self.cityNameLabel.backgroundColor = [UIColor clearColor];
    self.cityNameLabel.textAlignment = NSTextAlignmentCenter;
    self.cityNameLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:cityHeight-10.0];
    //self.cityNameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2.0 - sideLength/2.0, sideLength + cityHeight - 10,sideLength, cityHeight)];
    self.weatherLabel.backgroundColor = [UIColor clearColor];
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.weatherLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:cityHeight-12.0];
    //self.weatherLabel.adjustsFontSizeToFitWidth = YES;

    self.tempLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-sideLength)/2.0, 2*cityHeight + sideLength - 10, sideLength, tempHeight)];
    self.tempLabel.textAlignment = NSTextAlignmentCenter;
    self.tempLabel.font = [UIFont fontWithName:@"Helvetica" size:tempHeight - 5.0];
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
