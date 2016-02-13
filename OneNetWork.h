//
//  OneNetWork.h
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(NSData *data, NSURLResponse *response); //  回调

typedef void (^ErrorBlock)(NSError *error); //错误回调

@interface OneNetWork : NSObject

+ (OneNetWork *)sharedManager;

- (void)synchronousRequestWithURLString:(NSString *)URLString WithRequestMethod:(NSString *)method params:(NSDictionary *)params withCompletion:(Completion)completion withError:(ErrorBlock)finishError;

- (void)asynchronousRequestWithURLString:(NSString *)URLString WithRequestMethod:(NSString *)method params:(NSDictionary *)params withCompletion:(Completion)completion withError:(ErrorBlock)finishError;


@end
