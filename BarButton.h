//
//  BarButton.h
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarButton;

@protocol BarButtonDelegate <NSObject>

- (void)barButtonFirstPress:(BarButton *)sender;
- (void)barButtonSecondPress:(BarButton *)sender;

@end

@interface BarButton : UIButton

@property (nonatomic, weak) id<BarButtonDelegate> delegate;

@property (nonatomic, getter=isTouched) BOOL touched;

@end
