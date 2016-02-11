//
//  subButton.h
//  iWeather
//
//  Created by VicChan on 16/2/11.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class subButton;
@protocol subButtonDelegate <NSObject>

- (void)subButtonPress:(subButton *)button;

@end


@interface subButton : UIButton

@property (nonatomic, weak) id<subButtonDelegate> delegate;

@end
