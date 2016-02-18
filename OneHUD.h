//
//  OneHUD.h
//  iWeather
//
//  Created by VicChan on 16/2/18.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface OneHUD : UIView
{
    Circle *leftCircle;
    Circle *middleCircle;
    Circle *rightCircle;
}

@property (nonatomic) BOOL animating;
@property (nonatomic, assign) float interval;
@property int pointDiameter;

- (id)initWithFrame:(CGRect)frame withPointDiameter:(int)diameter interval:(float)interval;

@end
