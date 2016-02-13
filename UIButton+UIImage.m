//
//  UIButton+UIImage.m
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "UIButton+UIImage.h"

@implementation UIButton (UIImage)

- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {

    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,0,21,0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeScaleAspectFit];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(29,-image.size.width,0,0)];
    [self setTitle:title forState:stateType];
   
    
    }

@end
