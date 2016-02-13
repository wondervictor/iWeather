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

- (void)BarButtonPress:(BarButton *)sender;

@end

@interface BarButton : UIButton

@property (nonatomic, weak) id<BarButtonDelegate> delegate;

@property (nonatomic, strong) UIImageView *barImageView;
@property (nonatomic, strong) UILabel *barLabel;

@end
