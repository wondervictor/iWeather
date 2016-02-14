//
//  TabBar.m
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//


#import "TabBar.h"
#import "UIButton+UIImage.h"

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
    locationXAxis == 0 ? (self.centerLocationY = 25):(self.centerLocationY = locationYAxis);

    self.centerRadius = centerRadius;
    self.subRadius = subRadius;
    self.totalRadius = totalRadius;
    self.centerImage = centerImage;
    _expanded = NO;
    
    kSubButtonBirthLocation = CGPointMake(KWIDTH/2.0 ,KHEIGHT + 20);
    kSubButtonFinalLocation = CGPointMake(self.centerLocationX,self.centerLocationY);
    
    if (self = [super initWithFrame:frame]) {
        [self configureCenterButton:centerRadius image:centerImage];
        [self configureSubButtons];
        imageBlock(self);
        [self configureTabButtons];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (BOOL)isExpanded{
    return _expanded;
}

- (void)subButtonImage:(NSString *)imageName withTag:(NSInteger)tag{
    subButton *button = [self.subButtons objectAtIndex:tag];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)configureSubButtons {
    kSubButton_0_AppearLocation = CGPointMake(self.centerLocationX - self.totalRadius,self.centerLocationY );
    kSubButton_1_AppearLocation = CGPointMake(self.centerLocationX - self.totalRadius/2,self.centerLocationY );
    kSubButton_2_AppearLocation = CGPointMake(self.centerLocationX + self.totalRadius/2, self.centerLocationY);
    kSubButton_3_AppearLocation = CGPointMake(self.centerLocationX + self.totalRadius, self.centerLocationY);
    
    self.subButtons = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < 4; i ++) {
        subButton *button = [[subButton alloc]init ];
        button.delegate = self;
        button.frame = CGRectMake(0, 0,self.subRadius * 2 ,self.subRadius * 2 );
        button.center = kSubButtonBirthLocation;
        button.layer.cornerRadius = self.subRadius;
        button.layer.masksToBounds = YES;
        NSString *imageFormat = [NSString stringWithFormat:@"dc_button_%ld",(long)i];
        [button setImage:[UIImage imageNamed:imageFormat] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.subButtons addObject:button];
    }
    
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
  //  [_delegate centerButtonClick];
    if (![self isExpanded]) {
        //  tabBar Buttons disappear
        [UIView animateWithDuration:0.3f animations:^{
            CGPoint finalLocation_1 = CGPointMake(-50, 25);
            CGPoint finalLocation_2 = CGPointMake(50+KWIDTH, 25);
            UIButton *button_0 = (UIButton *)[self.tabButtons objectAtIndex:0];
            button_0.center = finalLocation_1;
            UIButton *button_1 = (UIButton *)[self.tabButtons objectAtIndex:1];
            button_1.center = finalLocation_1;
            
            UIButton *button_2 = (UIButton *)[self.tabButtons objectAtIndex:2];
            button_2.center = finalLocation_2;
            UIButton *button_3 = (UIButton *)[self.tabButtons objectAtIndex:3];
            button_3.center = finalLocation_2;
            
        
        } completion:nil];
        
        
        [self button:[self.subButtons objectAtIndex:0] appearAt:kSubButton_0_AppearLocation withDelay:0.5 duration:0.35];
        [self button:[self.subButtons objectAtIndex:1] appearAt:kSubButton_1_AppearLocation withDelay:0.55 duration:0.40];
        [self button:[self.subButtons objectAtIndex:2] appearAt:kSubButton_2_AppearLocation withDelay:0.60 duration:0.45];
        [self button:[self.subButtons objectAtIndex:3] appearAt:kSubButton_3_AppearLocation withDelay:0.65 duration:0.50];
        self.expanded = YES;
    }
    else {
        
        [self button:[self.subButtons objectAtIndex:0] shrinkAt:kSubButton_0_AppearLocation OffSetX:-10.0f andOffSetY:0.0 direction:kSubButtonRotationNormal withDelay:0.4f duration:0.8f];
        [self button:[self.subButtons objectAtIndex:1] shrinkAt:kSubButton_1_AppearLocation OffSetX:-10.0f andOffSetY:0 direction:kSubButtonRotationNormal withDelay:0.5f duration:1.0f];
        [self button:[self.subButtons objectAtIndex:2] shrinkAt:kSubButton_2_AppearLocation OffSetX:10.0f andOffSetY:0 direction:kSubButtonRotationReverse withDelay:0.6f duration:1.2f];
        [self button:[self.subButtons objectAtIndex:3] shrinkAt:kSubButton_3_AppearLocation OffSetX:10.0f andOffSetY:0 direction:kSubButtonRotationReverse withDelay:0.7f duration:1.4f];
        
        [UIView animateWithDuration:0.4f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UIButton *button_0 = (UIButton *)[self.tabButtons objectAtIndex:0];
            button_0.center = kTabButton_0_Location;
            UIButton *button_1 = (UIButton *)[self.tabButtons objectAtIndex:1];
            button_1.center = kTabButton_1_Location;
            
            UIButton *button_2 = (UIButton *)[self.tabButtons objectAtIndex:2];
            button_2.center = kTabButton_2_Location;
            UIButton *button_3 = (UIButton *)[self.tabButtons objectAtIndex:3];
            button_3.center = kTabButton_3_Location;
        }completion:nil];

        self.expanded = NO;
    }
    
}

- (void)configureTabButtons {
    CGFloat btnWidth = (KWIDTH-60) / 4.0;
   
    kTabButton_0_Location = CGPointMake(btnWidth/2,25);
    kTabButton_1_Location = CGPointMake(3*btnWidth/2, 25);
    kTabButton_2_Location = CGPointMake(60+5*btnWidth/2, 25);
    kTabButton_3_Location = CGPointMake(60+7*btnWidth/2, 25);
    
    NSArray *titlesArray = @[@"weekTemp",@"PM 2.5",@"Location",@"Info"];
    NSArray *imageArray = @[@"week1",@"pm251",@"location1",@"info1"];
    
    self.tabButtons = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 4; i++) {
        BarButton *button = [[BarButton alloc]init];
        //UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, 0, btnWidth, 50);
        if (i > 1) {
            button.center = CGPointMake((2*i + 1)*btnWidth/2 + 60, 25);
        }
        else {
            button.center = CGPointMake((2*i+1)*btnWidth/2, 25);
        }
        
        [button setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] withTitle:[titlesArray objectAtIndex:i] forState:UIControlStateNormal];
        button.delegate = self;
        button.layer.zPosition = 1;
        [self addSubview:button];
        [self.tabButtons addObject:button];
        
    }
    
}


// UIAmimation for Sub Buttons

- (void)button:(subButton *)button appearAt:(CGPoint)location withDelay:(CGFloat)delay duration:(CGFloat)duration {
    button.center = location;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration = duration;
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1,1 )],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    scaleAnimation.calculationMode = kCAAnimationLinear;
    scaleAnimation.keyTimes = @[[NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:delay],
                                [NSNumber numberWithFloat:1.0f]];
    button.layer.anchorPoint = CGPointMake(0.5f,0.5f);
    [button.layer addAnimation:scaleAnimation forKey:@"buttonAppear"];
}

- (void)button:(subButton *)button shrinkAt:(CGPoint)location OffSetX:(CGFloat)AxisX andOffSetY:(CGFloat)AxisY direction:(NSInteger)direction withDelay:(CGFloat)delay duration:(CGFloat)duration {
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = duration;
    rotationAnimation.values = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:2*M_PI*direction],[NSNumber numberWithFloat:1.0f]];
    rotationAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:delay],[NSNumber numberWithFloat:1.0f]];
    
    CAKeyframeAnimation *shrinkAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    shrinkAnimation.duration = duration * (1-delay);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, location.x, location.y);
    CGPathAddLineToPoint(path, NULL, location.x + AxisX, location.y + AxisY);
    CGPathAddLineToPoint(path, NULL, kSubButtonFinalLocation.x, kSubButtonFinalLocation.y);
    shrinkAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *totalAnimation = [CAAnimationGroup animation];
    totalAnimation.animations = @[rotationAnimation,shrinkAnimation];
    totalAnimation.duration = 1.0f;
    totalAnimation.fillMode = kCAFillModeForwards;
    totalAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    totalAnimation.delegate = self;
    button.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    button.center = kSubButtonBirthLocation;
    [button.layer addAnimation:totalAnimation forKey:@"buttonDismiss"];
    
}

#pragma mark - subButtonDelegate

- (void)subButtonPress:(subButton *)button {
    if ([_delegate respondsToSelector:@selector(subButton_0_Action)]&&button == [self.subButtons objectAtIndex:0]) {
        [_delegate subButton_0_Action];
    }
    else if ([_delegate respondsToSelector:@selector(subButton_1_Action)]&&button == [self.subButtons objectAtIndex:1]) {
        [_delegate subButton_1_Action];
    }
    else if ([_delegate respondsToSelector:@selector(subButton_2_Action)]&&button == [self.subButtons objectAtIndex:2]) {
        [_delegate subButton_2_Action];
    }
    else if ([_delegate respondsToSelector:@selector(subButton_3_Action)]&&button == [self.subButtons objectAtIndex:3]) {
        [_delegate subButton_3_Action];
    }
}


#pragma mark  - BarButtonDelegate
- (void)barButtonFirstPress:(BarButton *)sender {
    if (sender == [self.tabButtons objectAtIndex:0]) {
        [_delegate firstTouchAtIndex:0 button:sender];
        [self buttonAtIndex:0 enableOtherButtons:NO];
    }
    else if (sender == [self.tabButtons objectAtIndex:1])
    {
        [_delegate firstTouchAtIndex:1 button:sender];
        [self buttonAtIndex:1 enableOtherButtons:NO];

    }
    else if (sender == [self.tabButtons objectAtIndex:2])
    {
        [_delegate firstTouchAtIndex:2 button:sender];
        [self buttonAtIndex:2 enableOtherButtons:NO];

    }
    else if (sender == [self.tabButtons objectAtIndex:3])
    {
        [_delegate firstTouchAtIndex:3 button:sender];
        [self buttonAtIndex:3 enableOtherButtons:NO];

    }
}

- (void)barButtonSecondPress:(BarButton *)sender {
    if (sender == [self.tabButtons objectAtIndex:0]) {
        [_delegate secondTouchAtIndex:0 button:sender];
        [self buttonAtIndex:0 enableOtherButtons:YES];
    }
    else if (sender == [self.tabButtons objectAtIndex:1])
    {
        [_delegate secondTouchAtIndex:1 button:sender];
        [self buttonAtIndex:1 enableOtherButtons:YES];

    }
    else if (sender == [self.tabButtons objectAtIndex:2])
    {
        [_delegate secondTouchAtIndex:2 button:sender];
        [self buttonAtIndex:2 enableOtherButtons:YES];

    }
    else if (sender == [self.tabButtons objectAtIndex:3])
    {
        [_delegate secondTouchAtIndex:3 button:sender];
        [self buttonAtIndex:3 enableOtherButtons:YES];

    }
}

//  Tab Button only one enabled one time
- (void)buttonAtIndex:(NSInteger)index enableOtherButtons:(BOOL)enabled {
    if (enabled) {
        for (BarButton *button in self.tabButtons) {
            button.enabled = YES;
        }
    }
    else if (!enabled) {
        for (BarButton *button in self.tabButtons) {
            button.enabled = NO;
        }
        BarButton *button = [self.tabButtons objectAtIndex:index];
        button.enabled = YES;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
