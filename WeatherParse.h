//
//  WeatherParse.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//
///  Parse the Data 

#import "RealTimeWeather.h"
#import "WeekWeather.h"
#import "LifeWeather.h"

#import <Foundation/Foundation.h>

@interface WeatherParse : NSObject

+ (WeatherParse *)sharedManager;
- (NSDictionary *)getWeatherData:(NSData *)data;
- (RealTimeWeather *)parseRealTimeWeather:(NSDictionary *)weather;
//- (WeekWeather *)parseWeekWeather:(NSDictionary *)weather;
- (LifeWeather *)parseLifeWeather:(NSDictionary *)weather;
- (NSMutableArray *)getWeekWeatherArray:(NSDictionary *)weather;
- (NSMutableDictionary *)parseForConditionView:(NSDictionary *)weather;

@end
