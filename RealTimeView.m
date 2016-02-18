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
//   1 : 3
//
// iPhone4/4s         : H:91.5     W:320
// iPhone5/5s/5c      : H:113.5    W:320
// iPhone6/6s         : H:138.25   W:375
// iPhone6+/iPhone6s+ : H:155.5    W:414
// ConditionView
//     农历：     lunarLabel｜日出：       sunrise
//     污染： pollutionLabel｜日落：        sunset
//
//     湿度：   humidtyLabel｜风向： windDirection
//     紫外线：       UVRAYS｜ 风速：    windSpeed


#import "RealTimeView.h"

#define WIDTH  self.frame.size.width
#define HEIGHT self.frame.size.height

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface RealTimeView()
{
    UILabel *lunarLabel;
    UILabel *pollutionLabel;
    UILabel *humidtyLabel;
    UILabel *uvLabel;
    UILabel *sunriseLabel;
    UILabel *sunsetLabel;
    UILabel *windDirectLabel;
    UILabel *windSpeedLabel;
    CGFloat conditionViewY;  //  ConditionView Y 坐标
}
@property (nonatomic, assign) CGFloat proportion;
@end

@implementation RealTimeView

- (id)initWithFrame:(CGRect)frame withRealTimeWeather:(RealTimeWeather *)realWeather withConditionData:(NSDictionary *)dict
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
        CGFloat labelHeight = 20 * _proportion;
        CGFloat spaceDistance = 4 * _proportion;
        conditionViewY = 3*HEIGHT/4.0;
        
        [self configureComponentsWithSideLength:sideLength withTempHeight:tempHeight];
        [self configureImage:realWeather.img];

        [self configureViewWithLabelHeight:labelHeight spaceDistance:spaceDistance];
        [self configureInfoLabelWithDict:dict withLabelHeight:labelHeight spaceDistance:spaceDistance];
        
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
    
    CGFloat cityHeight = (3*HEIGHT/4 - (sideLength + tempHeight))/2;    // 城市标签高度
    
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


// ConditionView


- (void)configureViewWithLabelHeight:(CGFloat)labelHeight
                       spaceDistance:(CGFloat)spaceDistance {
    lunarLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, spaceDistance + conditionViewY, 70, labelHeight)];
    lunarLabel.text = @"农历:";
    [self configureTitleLabels:lunarLabel withLabelHeight:labelHeight];
    
    pollutionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, spaceDistance + labelHeight+ conditionViewY, 70, labelHeight)];
    pollutionLabel.text = @"污染:";
    [self configureTitleLabels:pollutionLabel withLabelHeight:labelHeight];
    
    humidtyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (labelHeight +spaceDistance)*2+ conditionViewY , 70, labelHeight)];
    humidtyLabel.text = @"湿度:";
    [self configureTitleLabels:humidtyLabel withLabelHeight:labelHeight];
    
    uvLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, labelHeight*3+spaceDistance*2+ conditionViewY, 70, labelHeight)];
    uvLabel.text = @"紫外线:";
    [self configureTitleLabels:uvLabel withLabelHeight:labelHeight];
    
    //    ***    //
    
    sunriseLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, spaceDistance+ conditionViewY, 70, labelHeight)];
    sunriseLabel.text = @"日出:";
    [self configureTitleLabels:sunriseLabel withLabelHeight:labelHeight];
    
    sunsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, spaceDistance + labelHeight+ conditionViewY, 70, labelHeight)];
    sunsetLabel.text = @"日落:";
    [self configureTitleLabels:sunsetLabel withLabelHeight:labelHeight];
    
    windDirectLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, (labelHeight +spaceDistance)*2+ conditionViewY, 70, labelHeight)];
    windDirectLabel.text = @"风向:";
    [self configureTitleLabels:windDirectLabel withLabelHeight:labelHeight];
    
    windSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, labelHeight*3+spaceDistance*2+ conditionViewY, 70, labelHeight)];
    windSpeedLabel.text = @"风速:";
    [self configureTitleLabels:windSpeedLabel withLabelHeight:labelHeight];
    
    
}

- (void)configureTitleLabels:(UILabel *)label withLabelHeight:(CGFloat)labelHeight {
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:10+labelHeight/9.0];
    [self addSubview:label];
}

- (void)configureInfoLabelWithDict:(NSDictionary *)dict
                   withLabelHeight:(CGFloat)labelHeight
                     spaceDistance:(CGFloat)spaceDistance {
    
    CGFloat middle = WIDTH/2;
    self.lunarDate = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, spaceDistance+ conditionViewY, 70, labelHeight)];
    self.lunarDate.text = [dict valueForKey:@"lunardate"];
    [self configureInfoLabels:self.lunarDate withLabelHeight:labelHeight];
    
    self.pollution = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, spaceDistance + labelHeight+ conditionViewY, 70, labelHeight)];
    self.pollution.text = [dict valueForKey:@"pollution"];
    [self configureInfoLabels:self.pollution withLabelHeight:labelHeight];
    
    self.humidty = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, 2*(spaceDistance +labelHeight)+ conditionViewY, 70, labelHeight)];
    self.humidty.text = [dict valueForKey:@"humidty"];
    [self configureInfoLabels:self.humidty withLabelHeight:labelHeight];
    
    self.uvrays = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, 2*spaceDistance + 3*labelHeight+ conditionViewY, 70, labelHeight)];
    self.uvrays.text = [dict valueForKey:@"uvray"];
    [self configureInfoLabels:self.uvrays withLabelHeight:labelHeight];
    
    self.sunrise = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, spaceDistance+ conditionViewY, 70, labelHeight)];
    self.sunrise.text = [dict valueForKey:@"sunrise"];
    [self configureInfoLabels:self.sunrise withLabelHeight:labelHeight];
    
    self.sunset = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, spaceDistance + labelHeight+ conditionViewY, 70, labelHeight)];
    self.sunset.text = [dict valueForKey:@"sunset"];
    [self configureInfoLabels:self.sunset withLabelHeight:labelHeight];
    
    
    self.windDirection = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80,  2*(spaceDistance +labelHeight)+ conditionViewY, 70, labelHeight)];
    self.windDirection.text = [dict valueForKey:@"winddirection"];
    [self configureInfoLabels:self.windDirection withLabelHeight:labelHeight];
    
    
    self.windSpeed = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, 2*spaceDistance + 3*labelHeight+ conditionViewY, 70, labelHeight)];
    self.windSpeed.text = [dict valueForKey:@"windspeed"];
    [self configureInfoLabels:self.windSpeed withLabelHeight:labelHeight];
    
}

- (void)configureInfoLabels:(UILabel *)label withLabelHeight:(CGFloat)labelHeight {
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10+labelHeight/10];
    [self addSubview:label];
}



@end
