//
//  UIButton+UIImage.h
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIImage)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

@end
