//
//  WeekWeather.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

///  一周天气


#import <Foundation/Foundation.h>

@interface WeekWeather : NSObject

@property (nonatomic, strong) NSArray *dayWeather;
@property (nonatomic, strong) NSArray *nightWeather;

@property (nonatomic, assign) NSString *date;
@property (nonatomic, assign) NSString *weekSeq;

@end
