//
//  RealTimeWeather.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

///  实时天气

#import <Foundation/Foundation.h>

@interface RealTimeWeather : NSObject

@property (nonatomic, assign) NSString *cityName;
@property (nonatomic, assign) NSString *weatherCondition;
@property (nonatomic, strong) NSDictionary *windCondition;
@property (nonatomic, assign) NSString *date;
@property (nonatomic, assign) NSString *humidty;
@property (nonatomic, assign) NSString *weatherTemp;

@end
