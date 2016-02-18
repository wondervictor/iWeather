//
//  OneHUD.m
//  iWeather
//
//  Created by VicChan on 16/2/18.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "OneHUD.h"

@implementation OneHUD

- (id)initWithFrame:(CGRect)frame withPointDiameter:(int)diameter interval:(float)interval {
    if (self = [super initWithFrame:frame]) {
        self.interval = interval;
        self.pointDiameter = diameter;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.layer.cornerRadius = 15;
        
        leftCircle = [self addCircleViewWithXOffsetFromCenter:-35];
        middleCircle = [self addCircleViewWithXOffsetFromCenter:0];
        rightCircle = [self addCircleViewWithXOffsetFromCenter:35];
        self.animating = YES;
        NSArray *circles = @[leftCircle, middleCircle, rightCircle];
        [self animateWithViews:circles index:0 delay:self.interval offSet:self.pointDiameter];
        [self animateWithViews:circles index:1 delay:self.interval offSet:self.pointDiameter];
        [self animateWithViews:circles index:2 delay:self.interval offSet:self.pointDiameter];
        
    }
    return self;
}

- (Circle *)addCircleViewWithXOffsetFromCenter:(float)offsetX {
    CGRect rect = CGRectMake(0, 0, self.pointDiameter, self.pointDiameter);
    Circle *circle = [[Circle alloc]initWithFrame:rect];
    circle.center = self.center;
    circle.frame = CGRectOffset(circle.frame, offsetX, 0);
    [self addSubview:circle];
    return circle;
}

- (void)animateWithViews:(NSArray *)circles index:(int)index delay:(float)delay offSet:(float)offset {
    UIView *view = (Circle *)[circles objectAtIndex:index];
    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = CGRectMake(view.frame.origin.x - offset/2, view.frame.origin.y - offset/2,view.frame.size.width + offset ,view.frame.size.height + offset);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.frame = CGRectMake(view.frame.origin.x + offset/2, view.frame.origin.y + offset/2, view.frame.size.width - offset, view.frame.size.height - offset);
        } completion:^(BOOL finished) {
            if (self.animating) {
                if (index == 2) {
                    [self animateWithViews:circles index:0 delay:self.interval*2 offSet:self.pointDiameter];
                    [self animateWithViews:circles index:1 delay:self.interval*3 offSet:self.pointDiameter];
                    [self animateWithViews:circles index:2 delay:self.interval*4 offSet:self.pointDiameter];
                }
            }
        }];
     
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
