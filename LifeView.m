//
//  LifeView.m
//  iWeather
//
//  Created by VicChan on 16/2/18.
//  Copyright © 2016年 VicChan. All rights reserved.
//
#define WIDTH  self.frame.size.width

#import "LifeView.h"

@interface LifeView()
{
    UILabel *airLabel;
    UILabel *airDesLabel;
    UILabel *sportLabel;
    UILabel *sportDesLabel;
    UILabel *sickLabel;
    UILabel *sickDesLabel;
    UILabel *clothLabel;
    UILabel *clothDesLabel;
    
}
@end

@implementation LifeView

- (id)initWithFrame:(CGRect)frame withData:(LifeWeather *)life {
    if (self = [super initWithFrame:frame]) {
        airLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 30)];
        airLabel.backgroundColor = [UIColor clearColor];
        airLabel.textColor = [UIColor orangeColor];
        airLabel.text = [NSString stringWithFormat:@"空调：%@",[life.airConditioner objectAtIndex:0]];
        
        airDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30,WIDTH ,40)];
        airDesLabel.backgroundColor = [UIColor clearColor];
        airDesLabel.textColor = [UIColor grayColor];
        airDesLabel.numberOfLines = 2;
        airDesLabel.adjustsFontSizeToFitWidth = YES;
        airDesLabel.text = [life.airConditioner objectAtIndex:1];
        
        sportLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 200, 30)];
        sportLabel.textColor = [UIColor orangeColor];
        sportLabel.backgroundColor = [UIColor clearColor];
        sportLabel.text = [NSString stringWithFormat:@"运动：%@",[life.sport objectAtIndex:0]];
        
        sportDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 40)];
        sportDesLabel.backgroundColor = [UIColor clearColor];
        sportDesLabel.textColor = [UIColor grayColor];
        sportDesLabel.numberOfLines = 2;
        sportDesLabel.adjustsFontSizeToFitWidth = YES;
        sportDesLabel.text = [life.sport objectAtIndex:1];
        
        sickLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, 200, 30)];
        sickLabel.backgroundColor = [UIColor clearColor];
        sickLabel.textColor = [UIColor orangeColor];
        sickLabel.text = [NSString stringWithFormat:@"感冒：%@",[life.illness objectAtIndex:0]];
        
        sickDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, WIDTH, 40)];
        sickDesLabel.backgroundColor = [UIColor clearColor];
        sickDesLabel.textColor = [UIColor grayColor];
        sickDesLabel.numberOfLines = 2;
        sickDesLabel.adjustsFontSizeToFitWidth = YES;
        sickDesLabel.text = [life.illness objectAtIndex:1];
        
        
        clothLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, 200, 30)];
        clothLabel.backgroundColor = [UIColor clearColor];
        clothLabel.textColor = [UIColor orangeColor];
        clothLabel.text = [NSString stringWithFormat:@"穿衣：%@",[life.clothes objectAtIndex:0]];
        
        clothDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 240,WIDTH , 40)];
        clothDesLabel.backgroundColor = [UIColor clearColor];
        clothDesLabel.textColor = [UIColor grayColor];
        clothDesLabel.numberOfLines = 2;
        clothDesLabel.adjustsFontSizeToFitWidth = YES;
        clothDesLabel.text = [life.clothes objectAtIndex:1];
        
        [self addSubview:airLabel];
        [self addSubview:airDesLabel];
        [self addSubview:sportLabel];
        [self addSubview:sportDesLabel];
        [self addSubview:sickLabel];
        [self addSubview:sickDesLabel];
        [self addSubview:clothLabel];
        [self addSubview:clothDesLabel];
        
        
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
