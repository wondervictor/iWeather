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

- (void)startRequestWithCityName:(NSString *)cityname {
    NSDictionary *requestParams = @{@"cityname":cityname,
                                    @"dtype":@"json",
                                    @"key":@"5e9055bef55f2e0ac8e3fdb4c0315629"};
    OneNetWork *oneNetWork = [OneNetWork sharedManager];
    [oneNetWork asynchronousRequestWithURLString:self.requestUrl WithRequestMethod:@"POST" params:requestParams withCompletion:^(NSData *data, NSURLResponse *response) {
        if (data != nil) {
            WeatherParse *paser = [WeatherParse sharedManager];
            NSDictionary *dict = [paser getWeatherData:data];
            if ([data isEqual:[NSNull null]]) {
                [_delegate weatherRequestFinished:nil withError:@"1"];
            }
            else{
                [_delegate weatherRequestFinished:dict withError:nil];
            }
            
        }
        else {
            [_delegate weatherRequestFinished:nil withError:@"3"];
        }
    } withError:^(NSError *error) {
        NSLog(@"def3");
        [_delegate weatherRequestFinished:nil withError:@"2"];
    }];
}


@end
