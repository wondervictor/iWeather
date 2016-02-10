//
//  WeatherParse.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "WeatherParse.h"

static WeatherParse *sharedManager = nil;
@implementation WeatherParse

+ (WeatherParse *)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        
        sharedManager = [[self alloc]init];
        
    });
    return sharedManager;
}

- (NSDictionary *)getWeatherData:(NSData *)data{
    NSDictionary *weatherDictionary;
    NSError *error = nil;
    id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *result = [dict valueForKey:@"result"];
    weatherDictionary = [result valueForKey:@"data"];
    
    return weatherDictionary;
}

- (RealTimeWeather *)parseRealTimeWeather:(NSDictionary *)weather{
    RealTimeWeather *real = [[RealTimeWeather alloc]init];
    NSDictionary *realWeatherDict = [weather valueForKey:@"realtime"];
    real.cityName = [realWeatherDict valueForKey:@"city_name"];
    real.date = [realWeatherDict valueForKey:@"date"];
    
    NSDictionary *wind = [realWeatherDict valueForKey:@"wind"];
    NSString *windSpeed = [NSString stringWithFormat:@"%@km/h",[wind valueForKey:@"windspeed"]];
    [wind setValue:windSpeed forKey:@"windspeed"];
    real.windCondition = wind;
    
    NSDictionary *weatherDict = [realWeatherDict valueForKey:@"weather"];
    real.weatherCondition = [weatherDict valueForKey:@"info"];
    real.weatherTemp = [NSString stringWithFormat:@"%@°",[weatherDict valueForKey:@"temperature"]];
    real.humidty = [weatherDict valueForKey:@"humidity"];
    
    return real;
}

// 多余
/*
- (WeekWeather *)parseWeekWeather:(NSDictionary *)weather{
    WeekWeather *weekDay = [[WeekWeather alloc]init];
    weekDay = [weather valueForKey:@"weather"];
    return weekDay;
}
*/
- (NSMutableArray *)getWeekWeatherArray:(NSDictionary *)weather{
    NSArray *listWeek = [weather valueForKey:@"weather"];
    NSMutableArray *listWeather = [[NSMutableArray alloc]initWithCapacity:7];
    for (NSDictionary *item in listWeek) {
        WeekWeather *oneDay = [[WeekWeather alloc]init];
        NSString *rawDate = [item valueForKey:@"date"];
        NSString *altetDate = [rawDate substringFromIndex:5];
        oneDay.date = altetDate;
        oneDay.weekSeq = [item valueForKey:@"week"];
        
        NSDictionary *weather = [item valueForKey:@"info"];
        oneDay.dayWeather = [weather valueForKey:@"day"];
        oneDay.nightWeather = [weather valueForKey:@"night"];
        [listWeather addObject:oneDay];
    }
    return listWeather;
}

- (LifeWeather *)parseLifeWeather:(NSDictionary *)weather{
    LifeWeather *life = [[LifeWeather alloc]init];
    NSDictionary *dict = [weather valueForKey:@"life"];
    NSDictionary *info = [dict valueForKey:@"info"];
    life.airConditioner = [info valueForKey:@"kongtiao"];
    life.sport = [info valueForKey:@"yundong"];
    life.UVRays = [info valueForKey:@"ziwaixian"];
    life.illness = [info valueForKey:@"ganmao"];
    life.pollution = [info valueForKey:@"wuran"];
    life.clothes = [info valueForKey:@"chuanyi"];
    return life;
}

@end
