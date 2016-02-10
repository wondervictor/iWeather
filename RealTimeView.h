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

- (id)initWithFrame:(CGRect)frame withRealTimeWeather:(RealTimeWeather *)realWeather;

@end
