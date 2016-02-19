//
//  OneNetWork.m
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "OneNetWork.h"

@interface OneNetWork()

@property (nonatomic, strong) NSURLSession *session;

@end

static OneNetWork *sharedManager = nil;

@implementation OneNetWork

+ (OneNetWork *)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
        [sharedManager session];
    });
    return sharedManager;
}
//  懒加载
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;    //  超时请求
        configuration.allowsCellularAccess = YES;
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (void)synchronousRequestWithURLString:(NSString *)URLString WithRequestMethod:(NSString *)method params:(NSDictionary *)params withCompletion:(Completion)completion withError:(ErrorBlock)finishError {
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSURL *url = [NSURL URLWithString:URLString];
    dispatch_sync(currentQueue, ^{
        if ([method caseInsensitiveCompare:@"GET"]==NSOrderedSame) {
            NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                if (!error) {
                    completion(data,response);
                } else {
                    finishError(error);
                }
            }];
            [task resume];
            
            
        }
        if ([method caseInsensitiveCompare:@"POST"]==NSOrderedSame) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            NSString *postString = [self parseParams:params];
            NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postData];
            NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error){
                completion (data, response);
            }];
            [task resume];
        }
    });
}

- (void)asynchronousRequestWithURLString:(NSString *)URLString WithRequestMethod:(NSString *)method params:(NSDictionary *)params withCompletion:(Completion)completion withError:(ErrorBlock)finishError {
    NSURL *url = [NSURL URLWithString:URLString];
    //dispatch_queue_t currentQueue = dispatch_get_main_queue();
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        if ([method caseInsensitiveCompare:@"GET"]==NSOrderedSame) {
            NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                if (!error) {
                    completion(data,response);
                } else {
                    finishError(error);
                }
            }];
            [task resume];
        }
        if ([method caseInsensitiveCompare:@"POST"]==NSOrderedSame) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            NSString *postString = [self parseParams:params];
            NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postData];
            NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error){
                completion (data, response);
            }];
            [task resume];
        }

    });
    
    
}

- (NSString *)parseParams:(NSDictionary *)params {
    NSString *keyValueFormat;
    NSMutableString *result = [[NSMutableString alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
        [array addObject:keyValueFormat];
    }
    return result;

}

/**
 
 DownLoad 
 UpLoad
 Parse Data
 Socket
 
 */









@end
