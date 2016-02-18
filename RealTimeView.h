//
//  RealTimeView.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//
#import "RealTimeWeather.h"


#import <UIKit/UIKit.h>

@interface RealTimeView : UIView

@property (nonatomic, strong) UIImageView *weatherImg;

@property (nonatomic, strong) UILabel *cityNameLabel;

@property (nonatomic, strong) UILabel *weatherLabel;

@property (nonatomic, strong) UILabel *tempLabel;

@property (nonatomic, strong) UILabel *sunrise;
@property (nonatomic, strong) UILabel *sunset;
@property (nonatomic, strong) UILabel *lunarDate;
@property (nonatomic, strong) UILabel *pollution;
@property (nonatomic, strong) UILabel *uvrays;
@property (nonatomic, strong) UILabel *windDirection;
@property (nonatomic, strong) UILabel *windSpeed;
@property (nonatomic, strong) UILabel *humidty;

- (id)initWithFrame:(CGRect)frame withRealTimeWeather:(RealTimeWeather *)realWeather withConditionData:(NSDictionary *)dict;

@end
