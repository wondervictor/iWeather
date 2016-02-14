//
//  TabBar.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "subButton.h"
#import "BarButton.h"

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>
- (void)firstTouchAtIndex:(NSInteger)index button:(BarButton *)sender;
- (void)secondTouchAtIndex:(NSInteger)index button:(BarButton *)sender;

- (void)subButton_0_Action;     // search
- (void)subButton_1_Action;     // add
- (void)subButton_2_Action;     // setting
- (void)subButton_3_Action;     // about

@optional
- (void)centerButtonClick;

@end


@interface TabBar : UIView<subButtonDelegate,BarButtonDelegate>
{
    // SubButton
    CGPoint kSubButtonBirthLocation;
    CGPoint kSubButtonFinalLocation;
    CGPoint kSubButton_0_AppearLocation;
    CGPoint kSubButton_1_AppearLocation;
    CGPoint kSubButton_2_AppearLocation;
    CGPoint kSubButton_3_AppearLocation;
 
    // TabBar Button
    CGPoint kTabButton_0_Location;    //  week temp
    CGPoint kTabButton_1_Location;    //  PM 2.5
    CGPoint kTabButton_2_Location;    //  Location
    CGPoint kTabButton_3_Location;    //  info

    
}

@property (nonatomic, weak) id<TabBarDelegate> delegate;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) subButton *subBtn;
@property (nonatomic, strong) NSMutableArray *subButtons;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) NSArray *tabBtnLocationXs;

@property (nonatomic, getter = isExpanded) BOOL expanded;
@property (nonatomic) CGFloat totalRadius;
@property (nonatomic) CGFloat centerRadius;
@property (nonatomic) CGFloat subRadius;
@property (nonatomic) CGFloat centerLocationX;
@property (nonatomic) CGFloat centerLocationY;
@property (nonatomic) NSString *centerImage;


- (id)initTabBarWithFrame:(CGRect)frame
          withTotalRadius:(CGFloat)totalRadius
             centerRadius:(CGFloat)centerRadius
                subRadius:(CGFloat)subRadius
              centerImage:(NSString *)centerImage
                subImages:(void(^)(TabBar *))imageBlock
                locationX:(CGFloat)locationXAxis
                locationY:(CGFloat)locationYAxis;

- (void)subButtonImage:(NSString *)imageName withTag:(NSInteger)tag;



@end
