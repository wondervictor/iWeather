//
//  weekViewCell.h
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//
// 这个类的命名是个错误 WeekViewCell

#import <UIKit/UIKit.h>

@interface weekViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *weather;

@property (weak, nonatomic) IBOutlet UILabel *temp;

@end
