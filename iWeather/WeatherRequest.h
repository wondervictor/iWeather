//
//  WeatherRequest.h
//  iWeather
//
//  Created by VicChan on 16/2/14.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "WeatherParse.h"
#import "OneNetWork.h"

#import <Foundation/Foundation.h>

@protocol WeatherRequestDelegate <NSObject>

- (void)weatherRequestFinished:(NSDictionary *)data withError:(NSString *)error;

@end

@interface WeatherRequest : NSObject

@property (nonatomic, strong) NSData *receivedData;
@property (nonatomic, assign) NSString *requestUrl;
@property (nonatomic, weak) id<WeatherRequestDelegate> delegate;

- (id)initRequest;
- (void)startRequestWithCityName:(NSString *)cityname;

@end
