//
//  WeatherRequest.m
//  iWeather
//
//  Created by VicChan on 16/2/14.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "WeatherRequest.h"

@implementation WeatherRequest

- (id)initRequest {
    self = [super init];
    if (self) {
        self.requestUrl = @"http://op.juhe.cn/onebox/weather/query?";
        
    }
    return self;
}

- (void)startRequest {
    NSDictionary *requestParams = @{@"cityname":@"宜昌",
                                    @"dtype":@"json",
                                    @"key":@"5e9055bef55f2e0ac8e3fdb4c0315629"};
    OneNetWork *oneNetWork = [OneNetWork sharedManager];
    [oneNetWork asynchronousRequestWithURLString:self.requestUrl WithRequestMethod:@"POST" params:requestParams withCompletion:^(NSData *data, NSURLResponse *response) {
        WeatherParse *paser = [WeatherParse sharedManager];
        NSDictionary *dict = [paser getWeatherData:data];
        [_delegate weatherRequestFinished:dict withError:nil];
    } withError:^(NSError *error) {
        [_delegate weatherRequestFinished:nil withError:@"网络连接失败"];
    }];
}


@end
