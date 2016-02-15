//
//  ConditionView.m
//  iWeather
//
//  Created by VicChan on 16/2/14.
//  Copyright © 2016年 VicChan. All rights reserved.
//
// iPhone4/4s         : H:91.5     W:320
// iPhone5/5s/5c      : H:113.5    W:320
// iPhone6/6s         : H:138.25   W:375
// iPhone6+/iPhone6s+ : H:155.5    W:414

#import "ConditionView.h"
//     样式：
//     农历：     lunarLabel｜日出：       sunrise
//     污染： pollutionLabel｜日落：        sunset
//
//     湿度：   humidtyLabel｜风向： windDirection
//     紫外线：       UVRAYS｜ 风速：    windSpeed
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define XWIDTH self.frame.size.width


@interface ConditionView()
{
    UILabel *lunarLabel;
    UILabel *pollutionLabel;
    UILabel *humidtyLabel;
    UILabel *uvLabel;
    UILabel *sunriseLabel;
    UILabel *sunsetLabel;
    UILabel *windDirectLabel;
    UILabel *windSpeedLabel;
    
}

@property (nonatomic, assign) CGFloat proportion;

@end

@implementation ConditionView

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        if (DEVICE_HEIGHT == 480.0) {
            _proportion = 1.0;
        }
        else if (DEVICE_HEIGHT == 568.0) {
            _proportion = 113.5/91.5;
        }
        else if (DEVICE_HEIGHT == 667.0) {
            _proportion = 138.25/91.5;
        }
        else if (DEVICE_HEIGHT == 736.0) {
            _proportion = 155.5/91.5;
        }
        CGFloat labelHeight = 20 * _proportion;
        CGFloat spaceDistance = 5 * _proportion;
        [self configureViewWithLabelHeight:labelHeight spaceDistance:spaceDistance];
        [self configureInfoLabelWithDict:dict withLabelHeight:labelHeight spaceDistance:spaceDistance];
        
    }
    return self;
}


- (void)configureViewWithLabelHeight:(CGFloat)labelHeight
                       spaceDistance:(CGFloat)spaceDistance {
    lunarLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, spaceDistance, 70, labelHeight)];
    lunarLabel.text = @"农历:";
    [self configureTitleLabels:lunarLabel withLabelHeight:labelHeight];
    
    pollutionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, spaceDistance + labelHeight, 70, labelHeight)];
    pollutionLabel.text = @"污染:";
    [self configureTitleLabels:pollutionLabel withLabelHeight:labelHeight];

    humidtyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (labelHeight +spaceDistance)*2 , 70, labelHeight)];
    humidtyLabel.text = @"湿度:";
    [self configureTitleLabels:humidtyLabel withLabelHeight:labelHeight];

    uvLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, labelHeight*3+spaceDistance*2, 70, labelHeight)];
    uvLabel.text = @"紫外线:";
    [self configureTitleLabels:uvLabel withLabelHeight:labelHeight];

    //    ***    //
    
    sunriseLabel = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH/2+10, spaceDistance, 70, labelHeight)];
    sunriseLabel.text = @"日出:";
    [self configureTitleLabels:sunriseLabel withLabelHeight:labelHeight];

    sunsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH/2+10, spaceDistance + labelHeight, 70, labelHeight)];
    sunsetLabel.text = @"日落:";
    [self configureTitleLabels:sunsetLabel withLabelHeight:labelHeight];

    windDirectLabel = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH/2+10, (labelHeight +spaceDistance)*2, 70, labelHeight)];
    windDirectLabel.text = @"风向:";
    [self configureTitleLabels:windDirectLabel withLabelHeight:labelHeight];

    windSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH/2+10, labelHeight*3+spaceDistance*2, 70, labelHeight)];
    windSpeedLabel.text = @"风速:";
    [self configureTitleLabels:windSpeedLabel withLabelHeight:labelHeight];
    

}

- (void)configureTitleLabels:(UILabel *)label withLabelHeight:(CGFloat)labelHeight {
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:labelHeight - 5.0];
    [self addSubview:label];
}

- (void)configureInfoLabelWithDict:(NSDictionary *)dict
                   withLabelHeight:(CGFloat)labelHeight
                     spaceDistance:(CGFloat)spaceDistance {
    
    CGFloat middle = XWIDTH/2;
    self.lunarDate = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, spaceDistance, 70, labelHeight)];
    self.lunarDate.text = [dict valueForKey:@"lunardate"];
    [self configureInfoLabels:self.lunarDate withLabelHeight:labelHeight];
    
    self.pollution = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, spaceDistance + labelHeight, 70, labelHeight)];
    self.pollution.text = [dict valueForKey:@"pollution"];
    [self configureInfoLabels:self.pollution withLabelHeight:labelHeight];

    self.humidty = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, 2*(spaceDistance +labelHeight), 70, labelHeight)];
    self.humidty.text = [dict valueForKey:@"humidty"];
    [self configureInfoLabels:self.humidty withLabelHeight:labelHeight];

    self.uvrays = [[UILabel alloc]initWithFrame:CGRectMake(middle-80, 2*spaceDistance + 3*labelHeight, 70, labelHeight)];
    self.uvrays.text = [dict valueForKey:@"uvray"];
    [self configureInfoLabels:self.uvrays withLabelHeight:labelHeight];

    self.sunrise = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH-80, spaceDistance, 70, labelHeight)];
    self.sunrise.text = [dict valueForKey:@"sunrise"];
    [self configureInfoLabels:self.sunrise withLabelHeight:labelHeight];

    self.sunset = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH-80, spaceDistance + labelHeight, 70, labelHeight)];
    self.sunset.text = [dict valueForKey:@"sunset"];
    [self configureInfoLabels:self.sunset withLabelHeight:labelHeight];

    
    self.windDirection = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH-80,  2*(spaceDistance +labelHeight), 70, labelHeight)];
    self.windDirection.text = [dict valueForKey:@"winddirection"];
    [self configureInfoLabels:self.windDirection withLabelHeight:labelHeight];

    
    self.windSpeed = [[UILabel alloc]initWithFrame:CGRectMake(XWIDTH-80, 2*spaceDistance + 3*labelHeight, 70, labelHeight)];
    self.windSpeed.text = [dict valueForKey:@"windspeed"];
    [self configureInfoLabels:self.windSpeed withLabelHeight:labelHeight];
    
}

- (void)configureInfoLabels:(UILabel *)label withLabelHeight:(CGFloat)labelHeight {
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:labelHeight - 5.0];
    [self addSubview:label];
}


@end
