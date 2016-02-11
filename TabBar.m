//
//  TabBar.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "TabBar.h"


#define ConvertAngleToRadian(x) ((x)*M_PI / 180)
#define kSubButtonRotationNormal   1
#define kSubButtonRotationReverse -1

#define KWIDTH  [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height


@implementation TabBar


- (id)initTabBarWithFrame:(CGRect)frame
          withTotalRadius:(CGFloat)totalRadius
             centerRadius:(CGFloat)centerRadius
                subRadius:(CGFloat)subRadius
              centerImage:(NSString *)centerImage
                subImages:(void (^)(TabBar *))imageBlock
                locationX:(CGFloat)locationXAxis
                locationY:(CGFloat)locationYAxis
{
    
    locationXAxis == 0 ? (self.centerLocationX = KWIDTH/2.0):(self.centerLocationX = locationXAxis);
    locationXAxis == 0 ? (self.centerLocationY = KHEIGHT-30):(self.centerLocationY = locationYAxis);

    self.centerRadius = centerRadius;
    self.subRadius = subRadius;
    self.totalRadius = totalRadius;
    self.centerImage = centerImage;
    _expanded = NO;
    
    kSubButtonBirthLocation = CGPointMake(KWIDTH/2.0 ,KHEIGHT + 30);
    kSubButtonFinalLocation = CGPointMake(self.centerLocationX,self.centerLocationY);
    
    if (self = [super initWithFrame:frame]) {
        
        
        
        
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configureSubButtons {
   // kSubButton_0_AppearLocation = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
    
    
}

- (void)configureCenterButton:(CGFloat)centerRadius image:(NSString *)imageName {
    self.centerButton = [[UIButton alloc]init];
    self.centerButton.frame = CGRectMake(0, 0, 2 * centerRadius, 2 * centerRadius);
    self.centerButton.center = CGPointMake(self.centerLocationX, self.centerLocationY);
    self.centerButton.layer.cornerRadius = centerRadius;
    self.centerButton.layer.masksToBounds = YES;
    [self.centerButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [self.centerButton addTarget:self
                          action:@selector(centerButtonPress)
                forControlEvents:UIControlEventTouchUpInside];
    self.centerButton.layer.zPosition = 1;
    [self addSubview:self.centerButton];
}

- (void)centerButtonPress {
    
}

- (void)configureTabButtons {
    
}

// UIAmimation for Sub Buttons





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
