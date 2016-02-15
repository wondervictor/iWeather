//
//  ConditionView.h
//  iWeather
//
//  Created by VicChan on 16/2/14.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConditionView : UIView

@property (nonatomic, strong) UILabel *sunrise;
@property (nonatomic, strong) UILabel *sunset;
@property (nonatomic, strong) UILabel *lunarDate;
@property (nonatomic, strong) UILabel *pollution;
@property (nonatomic, strong) UILabel *uvrays;
@property (nonatomic, strong) UILabel *windDirection;
@property (nonatomic, strong) UILabel *windSpeed;
@property (nonatomic, strong) UILabel *humidty;

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict;

@end
