//
//  PMView.m
//  iWeather
//
//  Created by VicChan on 16/2/18.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#define WIDTH   self.frame.size.width
#define HEIGHT  self.frame.size.height

#import "PMView.h"

@interface PMView()
{
    UILabel *pm25;
    UILabel *pm10;
    UILabel *quality;
    UILabel *level;
    UILabel *description;
}
@end


@implementation PMView

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict {
    if (self = [super initWithFrame:frame]) {
        pm25 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 40) ];
        pm25.backgroundColor = [UIColor clearColor];
        pm25.textAlignment = NSTextAlignmentLeft;
        pm25.textColor = [UIColor orangeColor];
        pm25.text = [NSString stringWithFormat:@"PM2.5指数：%@",[dict valueForKey:@"pm25"]];
        pm10 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-160, 10, 150, 40)];
        pm10.backgroundColor = [UIColor clearColor];
        pm10.textAlignment = NSTextAlignmentLeft;
        pm10.textColor = [UIColor orangeColor];
        pm10.text = [NSString stringWithFormat:@"PM10指数：%@",[dict valueForKey:@"pm10"]];
        quality = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 150, 40)];
        quality.backgroundColor = [UIColor clearColor];
        quality.textAlignment = NSTextAlignmentLeft;
        quality.textColor = [UIColor blackColor];
        quality.text =[ NSString stringWithFormat:@"质量：%@",[dict valueForKey:@"quality"]];
        level = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 110, 50, 100, 40)];
        level.backgroundColor = [UIColor clearColor];
        level.textAlignment = NSTextAlignmentLeft;
        level.textColor = [UIColor blackColor];
        level.text = [NSString stringWithFormat:@"等级：%@",[dict valueForKey:@"level"]];
        description = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, WIDTH-20, 80)];
        description.numberOfLines = 2;
        description.backgroundColor = [UIColor clearColor];
        description.textAlignment = NSTextAlignmentLeft;
        description.textColor = [UIColor grayColor];
        description.adjustsFontSizeToFitWidth = YES;
        description.text = [NSString stringWithFormat:@"描述：%@",[dict valueForKey:@"des"]];
        
        [self addSubview:pm10];
        [self addSubview:pm25];
        [self addSubview:quality];
        [self addSubview:level];
        [self addSubview:description];
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
